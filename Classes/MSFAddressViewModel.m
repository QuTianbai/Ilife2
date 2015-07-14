//
// MSFAddressViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAddressViewModel.h"
#import <UIKit/UIKit.h>
#import <FMDB/FMDB.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFAreas.h"
#import "MSFApplicationForms.h"

@interface MSFAddressViewModel ()

@property(nonatomic,strong) FMDatabase *fmdb;

@property(nonatomic,weak,readwrite) UIViewController *viewController;
@property(nonatomic,strong) MSFApplicationForms *form;

@end

@implementation MSFAddressViewModel

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFAddressViewModel ``-dealloc");
}

- (instancetype)initWithController:(UIViewController *)contentViewController {
	return [self initWithController:contentViewController needArea:NO];
}

- (instancetype)initWithWorkApplicationForm:(MSFApplicationForms *)model controller:(UIViewController *)viewController {
	if (!(self = [self initWithController:viewController needArea:YES])) {
		return nil;
	}
	self.province = [self regionWithCode:model.workProvinceCode];
	self.city = [self regionWithCode:model.workCityCode];
	self.area = [self regionWithCode:model.workCountryCode];
	
	return self;
}

- (instancetype)initWithApplicationForm:(MSFApplicationForms *)model controller:(UIViewController *)viewController {
	if (!(self = [self initWithController:viewController needArea:YES])) {
		return nil;
	}
	self.province = [self regionWithCode:model.currentProvinceCode];
	self.city = [self regionWithCode:model.currentCityCode];
	self.area = [self regionWithCode:model.currentCountryCode];
	
	return self;
}

- (instancetype)initWithController:(UIViewController *)contentViewController needArea:(BOOL)needArea {
  self = [super init];
  if (!self) {
    return nil;
  }
	NSString *path = [[NSBundle mainBundle] pathForResource:@"dicareas" ofType:@"db"];
	_fmdb = [FMDatabase databaseWithPath:path];
	_viewController = contentViewController;
	_address = @"";
	_needArea = needArea;
	
	@weakify(self)
	_selectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
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
	
	RAC(self,address) = [[RACSignal
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
			NSLog(@"`Address:`%@",x);
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
	
  return self;
}

#pragma mark - Private

- (RACSignal *)fetchProvince {
	MSFSelectionViewModel *provinceViewModel = [MSFSelectionViewModel areaViewModel:self.provinces];
	MSFSelectionViewController *viewController = [[MSFSelectionViewController alloc] initWithViewModel:provinceViewModel];
	viewController.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	viewController.title = @"中国";
	[self.viewController.navigationController pushViewController:viewController animated:YES];
	
	return [viewController.selectedSignal doNext:^(id x) {
		self.province = x;
	}];
}

- (RACSignal *)fetchCity {
	NSParameterAssert(self.province);
	MSFSelectionViewModel *citiesViewModel = [MSFSelectionViewModel areaViewModel:[self citiesWithProvince:self.province]];
	MSFSelectionViewController *viewController = [[MSFSelectionViewController alloc] initWithViewModel:citiesViewModel];
	viewController.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	viewController.title = self.province.title;
	[self.viewController.navigationController pushViewController:viewController animated:YES];
	
	return [viewController.selectedSignal doNext:^(id x) {
		self.city = x;
		if (!self.needArea) {
			[self.viewController.navigationController popToViewController:self.viewController animated:YES];
		}
	}];
}

- (RACSignal *)fetchArea {
	NSParameterAssert(self.city);
	MSFSelectionViewModel *areasViewModel = [MSFSelectionViewModel areaViewModel:[self areasWitchCity:self.city]];
	MSFSelectionViewController *viewController = [[MSFSelectionViewController alloc] initWithViewModel:areasViewModel];
	viewController.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	viewController.title = self.city.title;
	[self.viewController.navigationController pushViewController:viewController animated:YES];
	
	return [viewController.selectedSignal doNext:^(id x) {
		self.area = x;
		[self.viewController.navigationController popToViewController:self.viewController animated:YES];
	}];
}

#pragma mark - Custom Accessors

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
	NSString *sql = [NSString stringWithFormat:@"select * from basic_dic_area where parent_area_code='%@'",province.codeID];
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
	NSString *sql = [NSString stringWithFormat:@"select * from basic_dic_area where parent_area_code='%@'",city.codeID];
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
	NSString *sql = [NSString stringWithFormat:@"select * from basic_dic_area where area_code='%@'",code];
	FMResultSet *rs = [self.fmdb executeQuery:sql];
	MSFAreas *region;
	if (rs.next) {
		region = [MTLFMDBAdapter modelOfClass:[MSFAreas class] fromFMResultSet:rs error:nil];
	}
	[self.fmdb close];
	
  return region;
}

@end
