//
// MSFAddressViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAddressViewModel.h"
#import <FMDB/FMDB.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFAddress.h"
#import "MSFAddressCodes.h"

@interface MSFAddressViewModel ()

@property (nonatomic, strong) FMDatabase *fmdb;
@property (nonatomic, strong) id form DEPRECATED_ATTRIBUTE;
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

- (instancetype)initWithAddress:(MSFAddressCodes *)address services:(id <MSFViewModelServices>)services {
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
	
//	RAC(self, address) = [[RACSignal
//		combineLatest:@[
//			RACObserve(self, province),
//			RACObserve(self, city),
//			RACObserve(self, area),
//		]
//		reduce:^id(MSFAddress *province, MSFAddress *city, MSFAddress *area) {
//			NSMutableString *address = NSMutableString.string;
//			[address appendString:province.name ?: @""];
//			[address appendString:city.name ?: @""];
//			[address appendString:area.name ?: @""];
//			
//			return address;
//		}]
//		doNext:^(id x) {
//			NSLog(@"`Address:`%@", x);
//		}];
	
	RAC(self, provinceName) = RACObserve(self, province.name);
	RAC(self, provinceCode) = RACObserve(self, province.codeID);
	RAC(self, cityName) = RACObserve(self, city.name);
	RAC(self, cityCode) = RACObserve(self, city.codeID);
	RAC(self, areaName) = RACObserve(self, area.name);
	RAC(self, areaCode) = RACObserve(self, area.codeID);
}

- (RACSignal *)fetchProvince {
	MSFSelectionViewModel *provinceViewModel = [MSFSelectionViewModel areaViewModel:self.provinces];
	[self.services pushViewModel:provinceViewModel];
	return [provinceViewModel.selectedSignal doNext:^(id x) {
		self.province = x;
		[self.city mergeValuesForKeysFromModel:[[MSFAddress alloc] initWithDictionary:@{} error:nil]];
		[self.area mergeValuesForKeysFromModel:[[MSFAddress alloc] initWithDictionary:@{} error:nil]];
	}];
}

- (RACSignal *)fetchCity {
	NSParameterAssert(self.province);
	MSFSelectionViewModel *citiesViewModel = [MSFSelectionViewModel areaViewModel:[self citiesWithProvince:self.province]];
	[self.services pushViewModel:citiesViewModel];
	return [citiesViewModel.selectedSignal doNext:^(id x) {
		self.city = x;
		[self.area mergeValuesForKeysFromModel:[[MSFAddress alloc] initWithDictionary:@{} error:nil]];
		if (!self.needArea) {
            NSMutableString *address = NSMutableString.string;
            [address appendString:self.province.name ?: @""];
            [address appendString:self.city.name ?: @""];
            [address appendString:self.area.name ?: @""];
            self.address = address;
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
        NSMutableString *address = NSMutableString.string;
        [address appendString:self.province.name ?: @""];
        [address appendString:self.city.name ?: @""];
        [address appendString:self.area.name ?: @""];
        self.address = address;
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
		MSFAddress *areas = [MTLFMDBAdapter modelOfClass:MSFAddress.class fromFMResultSet:s error:&error];
		[regions addObject:areas];
		
	}
	NSMutableArray *temp = regions.mutableCopy;
	for (MSFAddress *area in regions) {
		if ([area.codeID isEqualToString:@"500000"]) {
			MSFAddress *tempArea = [[MSFAddress alloc] init];
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

- (NSArray *)citiesWithProvince:(MSFAddress *)province {
	[self.fmdb open];
	NSMutableArray *regions = [NSMutableArray array];
	NSString *sql = [NSString stringWithFormat:@"select * from basic_dic_area where parent_area_code='%@'", province.codeID];
	FMResultSet *rs = [self.fmdb executeQuery:sql];
	while ([rs next]) {
	MSFAddress *areas = [MTLFMDBAdapter modelOfClass:MSFAddress.class fromFMResultSet:rs error:nil];
		[regions addObject:areas];
	}
	[self.fmdb close];
	
	return regions;
}

- (NSArray *)areasWitchCity:(MSFAddress *)city {
	[self.fmdb open];
	NSMutableArray *regions = [NSMutableArray array];
	NSString *sql = [NSString stringWithFormat:@"select * from basic_dic_area where parent_area_code='%@'", city.codeID];
	FMResultSet *rs = [self.fmdb executeQuery:sql];
	while ([rs next]) {
	MSFAddress *areas = [MTLFMDBAdapter modelOfClass:MSFAddress.class fromFMResultSet:rs error:nil];
		[regions addObject:areas];
	}
	[self.fmdb close];
	
	return regions;
}

- (MSFAddress *)regionWithCode:(NSString *)code {
	[self.fmdb open];
	NSString *sql = [NSString stringWithFormat:@"select * from basic_dic_area where area_code='%@'", code];
	FMResultSet *rs = [self.fmdb executeQuery:sql];
	MSFAddress *region;
	if (rs.next) {
		region = [MTLFMDBAdapter modelOfClass:[MSFAddress class] fromFMResultSet:rs error:nil];
	}
	[self.fmdb close];
	
	return region;
}

@end
