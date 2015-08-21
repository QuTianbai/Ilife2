//
// MSFBasicViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFPersonalViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFAddressViewModel.h"
#import "MSFAreas.h"
#import "NSString+Matches.h"
#import <CoreLocation/CoreLocation.h>
#import "MSFLocationModel.h"
#import "MSFLocationModel.h"
#import "MSFResultModel.h"
#import "MSFAddressInfo.h"
#import <FMDB/FMDB.h>
#import "RCLocationManager.h"

@interface MSFPersonalViewModel ()

@property (nonatomic, readonly) MSFAddressViewModel *addressViewModel;
@property (nonatomic, weak) id <MSFViewModelServices> services;

@end

@implementation MSFPersonalViewModel

#pragma mark - Lifecycle

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)viewModel addressViewModel:(MSFAddressViewModel *)addressViewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
  _services = viewModel.services;
	if (CLLocationCoordinate2DIsValid([RCLocationManager sharedManager].location.coordinate)) {
		[self getLocationCoordinate:[RCLocationManager sharedManager].location.coordinate];
	}
	
	_formsViewModel = viewModel;
	_addressViewModel = addressViewModel;
	_model = viewModel.model;
	RAC(self, address) = RACObserve(self.addressViewModel, address);
	RAC(self.model, currentProvince) = RACObserve(self.addressViewModel, provinceName);
	RAC(self.model, currentProvinceCode) = RACObserve(self.addressViewModel, provinceCode);
	RAC(self.model, currentCity) = RACObserve(self.addressViewModel, cityName);
	RAC(self.model, currentCityCode) = RACObserve(self.addressViewModel, cityCode);
	RAC(self.model, currentCountry) = RACObserve(self.addressViewModel, areaName);
	RAC(self.model, currentCountryCode) = RACObserve(self.addressViewModel, areaCode);
	
	_executeAlterAddressCommand = self.addressViewModel.selectCommand;
	@weakify(self)
  _executeCommitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    @strongify(self);
    return [self commitSignal];
  }];
	
	return self;
}

- (void)getLocationCoordinate:(CLLocationCoordinate2D)coordinate {
  [[self.services fetchLocationWithLatitude:coordinate.latitude longitude:coordinate.longitude]
   subscribeNext:^(MSFLocationModel *model) {
     if (self.addressViewModel.isStopAutoLocation) {
       return;
     }
     //NSLog(@"%@",model);
     NSString *path = [[NSBundle mainBundle] pathForResource:@"dicareas" ofType:@"db"];
     FMDatabase *fmdb = [FMDatabase databaseWithPath:path];
     [fmdb open];
     NSError *error ;
     //NSMutableArray *regions = [NSMutableArray array];
     FMResultSet *s = [fmdb executeQuery:@"select * from basic_dic_area"];
     int i = 0;
     int j = 0;
     int k = 0;
     while ([s next]) {
       MSFAreas *area = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:s error:&error];
       if ([area.name isEqualToString:model.result.addressComponent.city]) {
         i++;
         MSFAreas *province = [[MSFAreas alloc] init];
         province.name = area.name;
         province.codeID = area.codeID;
         province.parentCodeID = area.parentCodeID;
         self.addressViewModel.province = province;
         if (i > 0 && j > 0 && k > 0) {
           break;
         }
       }
       if ([area.name isEqualToString:model.result.addressComponent.province]) {
         j++;
         MSFAreas *city = [[MSFAreas alloc] init];
         city.name = area.name;
         city.codeID = area.codeID;
         city.parentCodeID = area.parentCodeID;
         self.addressViewModel.city = city;
         if (i > 0 && j > 0 && k > 0) {
           break;
         }
       }
       if ([area.name isEqualToString:model.result.addressComponent.district]) {
         k++;
         MSFAreas *district = [[MSFAreas alloc] init];
         district.name = area.name;
         district.codeID = area.codeID;
         district.parentCodeID = area.parentCodeID;
         self.addressViewModel.area = district;
         if (i > 0 && j > 0 && k > 0) {
           break;
         }
       }
     }
   }
   error:^(NSError *error) {
     NSLog(@"%@", error);
   }];
}

#pragma mark - Private

- (RACSignal *)commitSignal {
  if ([self.model.income isEqualToString:@""]) {
    return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:@"请输入每月税前收入"}]];
  }
  if ([self.model.familyExpense isEqualToString:@""]) {
    return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:@"请输入其他贷款/信用卡每月应还金额"}]];
  }
  if ([self.model.otherIncome isEqualToString:@""]) {
    return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:@"请输入月其他收入"}]];
  } else if (![self.model.email isMail]) {
		return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请输正确的邮箱",
		}]];
	} else if (![self validAddress]) {
		return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"详细地址至少输入两项",
		}]];
	} else if (![self.model.qq isNum]) {
		return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请输入正确地qq号",
		}]];
	}
	
	return [self.formsViewModel submitSignalWithPage:2];
}

- (NSString *)checkForm {
	if ([self.model.income isEqualToString:@""]) {
		return @"请输入月工资收入";
	}
	if ([self.model.familyExpense isEqualToString:@""]) {
		return @"请输入每月还贷额";
	}
	if ([self.model.otherIncome isEqualToString:@""]) {
		return @"请输入月其他收入";
	}
	if (self.model.homeCode.length < 3 || ![self.model.homeCode isScalar]) {
		return @"请输入正确的住宅座机区号";
	}
	if (self.model.homeLine.length == 0) {
		return @"请填写完住宅电话";
	}
	if (![[self.model.homeCode stringByAppendingString:self.model.homeLine] isTelephone]) {
		return @"请输正确的住宅电话";
	}
	if (![self.model.email isMail]) {
		return @"请输正确的邮箱";
	}
	if (![self validAddress]) {
		return @"详细地址至少输入两项";
	}
	return nil;
}

- (RACSignal *)commitValidSignal {
	return [RACSignal
		combineLatest:@[
			RACObserve(self.model, income),
			RACObserve(self.model, otherIncome),
			RACObserve(self.model, familyExpense),
			RACObserve(self.model, currentProvince),
			RACObserve(self.model, currentCity),
			RACObserve(self.model, currentCountry),
		]
		reduce:^id(NSString *income, NSString *other, NSString *expense, NSString *province, NSString *city, NSString *country) {
			return @(
				[income isScalar] &&
				[other isScalar] &&
				[expense isScalar] &&
				province != nil &&
				city != nil &&
				country != nil
			);
		}];
}

- (BOOL)validAddress {
	NSInteger length1 = self.model.currentTown.length > 0 ? 1: 0;
	NSInteger length2 = self.model.currentCommunity.length > 0 ? 1: 0;
	NSInteger length3 = self.model.currentApartment.length > 0 ? 1: 0;
	NSInteger length4 = self.model.currentStreet.length > 0 ? 1: 0;
	
	return (length1 + length2 + length3 + length4) >= 2;
}

@end
