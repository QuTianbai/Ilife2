//
// MSFAddressViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAddressViewModel.h"
#import <FMDB/FMDB.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFAreas.h"
#import "MSFApplicationForms.h"
#import "MSFAddress.h"

@interface MSFAddressViewModel ()

@property (nonatomic, strong) FMDatabase *fmdb;
@property (nonatomic, strong) MSFApplicationForms *form;
@property (nonatomic, weak) id <MSFViewModelServices> services;

@end

@implementation MSFAddressViewModel

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFAddressViewModel ``-dealloc");
}

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_services = services;
	[self initialize];
  
  return self;
}

- (instancetype)initWithAddress:(MSFAddress *)address services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	[self initialize];
	_needArea = YES;
	self.services = services;
	self.province = [self regionWithCode:address.province];
	self.city = [self regionWithCode:address.city];
	self.area = [self regionWithCode:address.area];
	
  return self;
}

#pragma mark - Private

- (void)initialize {
	NSString *path = [[NSBundle mainBundle] pathForResource:@"dicareas" ofType:@"db"];
	_fmdb = [FMDatabase databaseWithPath:path];
	_address = @"";
	
	@weakify(self)
	_selectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
    self.isStopAutoLocation = YES;
		if (!self.needArea) {
			return [[[self fetchProvince]
				flattenMap:^RACStream *(id value) {
					return [self fetchCity];
				}]
				replayLast];
		}
		return [[[[self fetchProvince]
			flattenMap:^RACStream *(id value) {
				return [self fetchCity];
			}]
			flattenMap:^RACStream *(id value) {
				return [self fetchArea];
			}]
			replayLast];
	}];
	_selectCommand.allowsConcurrentExecution = YES;
	
	RAC(self, address) = [[RACSignal
		combineLatest:@[
			RACObserve(self, province),
			RACObserve(self, city),
			RACObserve(self, area),
		]
		reduce:^id(MSFAreas *province, MSFAreas *city, MSFAreas *area) {
			NSMutableString *address = NSMutableString.string;
			[address appendString:province.name ?: @""];
			[address appendString:^{
				if ([city.name isEqualToString:@"省"] ||
					[city.name isEqualToString:@"县"] ||
					[city.name isEqualToString:@"市辖区"] ||
					[city.name isEqualToString:@"区"] ||
					city.name == nil) {
					return @"";
				}
				return city.name;
			}()];
			[address appendString:area.name ?: @""];
			
			return address;
		}]
		doNext:^(id x) {
			NSLog(@"`Address:`%@", x);
		}];
	
	[[RACObserve(self, province) ignore:nil] subscribeNext:^(MSFAreas *x) {
		@strongify(self)
		self.provinceName = x.name;
		self.provinceCode = x.codeID;
	}];
	[[RACObserve(self, city) ignore:nil] subscribeNext:^(MSFAreas *x) {
		@strongify(self)
		self.cityName = x.name;
		self.cityCode = x.codeID;
	}];
	[[RACObserve(self, area) ignore:nil] subscribeNext:^(MSFAreas *x) {
		@strongify(self)
		self.areaName = x.name;
		self.areaCode = x.codeID;
	}];
}

- (RACSignal *)fetchProvince {
	MSFSelectionViewModel *provinceViewModel = [MSFSelectionViewModel areaViewModel:self.provinces];
	[self.services pushViewModel:provinceViewModel];
	return [provinceViewModel.selectedSignal doNext:^(id x) {
		self.province = x;
	}];
}

- (RACSignal *)fetchCity {
	NSParameterAssert(self.province);
	MSFSelectionViewModel *citiesViewModel = [MSFSelectionViewModel areaViewModel:[self citiesWithProvince:self.province]];
	[self.services pushViewModel:citiesViewModel];
	return [citiesViewModel.selectedSignal doNext:^(id x) {
		self.city = x;
		if (!self.needArea) {
			[self.services popViewModel];
		}
	}];
}

- (RACSignal *)fetchArea {
	NSParameterAssert(self.city);
	MSFSelectionViewModel *areasViewModel = [MSFSelectionViewModel areaViewModel:[self areasWitchCity:self.city]];
	[self.services pushViewModel:areasViewModel];
	return [areasViewModel.selectedSignal doNext:^(id x) {
		self.area = x;
		[self.services popViewModel];
	}];
}

- (NSArray *)provinces {
	if (![self.fmdb open]) {
		return nil;
	}
	NSError *error;
	NSMutableArray *regions = [NSMutableArray array];
	FMResultSet *s = [self.fmdb executeQuery:@"select * from basic_dic_area where parent_area_code='000000'"];
	while ([s next]) {
		MSFAreas *areas = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:s error:&error];
		[regions addObject:areas];
		
	}
	NSMutableArray *temp = regions.mutableCopy;
	for (MSFAreas *area in regions) {
		if ([area.codeID isEqualToString:@"500000"]) {
			MSFAreas *tempArea = [[MSFAreas alloc] init];
			tempArea.name = area.name;
			tempArea.codeID = area.codeID;
			tempArea.parentCodeID = area.parentCodeID;
			[temp removeObject:area];
			[temp insertObject:tempArea atIndex:1];
			break;
		}
	}
	[self.fmdb close];
	
	return temp;
}

- (NSArray *)citiesWithProvince:(MSFAreas *)province {
	[self.fmdb open];
	NSMutableArray *regions = [NSMutableArray array];
	NSString *sql = [NSString stringWithFormat:@"select * from basic_dic_area where parent_area_code='%@'", province.codeID];
	FMResultSet *rs = [self.fmdb executeQuery:sql];
	while ([rs next]) {
	MSFAreas *areas = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:rs error:nil];
		[regions addObject:areas];
	}
	[self.fmdb close];
	
	return regions;
}

- (NSArray *)areasWitchCity:(MSFAreas *)city {
	[self.fmdb open];
	NSMutableArray *regions = [NSMutableArray array];
	NSString *sql = [NSString stringWithFormat:@"select * from basic_dic_area where parent_area_code='%@'", city.codeID];
	FMResultSet *rs = [self.fmdb executeQuery:sql];
	while ([rs next]) {
	MSFAreas *areas = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:rs error:nil];
		[regions addObject:areas];
	}
	[self.fmdb close];
	
	return regions;
}

- (MSFAreas *)regionWithCode:(NSString *)code {
	[self.fmdb open];
	NSString *sql = [NSString stringWithFormat:@"select * from basic_dic_area where area_code='%@'", code];
	FMResultSet *rs = [self.fmdb executeQuery:sql];
	MSFAreas *region;
	if (rs.next) {
		region = [MTLFMDBAdapter modelOfClass:[MSFAreas class] fromFMResultSet:rs error:nil];
	}
	[self.fmdb close];
	
	return region;
}

@end
