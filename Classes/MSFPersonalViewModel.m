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
#import "MSFSelectionViewModel.h"
#import "MSFSelectKeyValues.h"

@implementation MSFPersonalViewModel

#pragma mark - Lifecycle

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)viewModel addressViewModel:(MSFAddressViewModel *)addressViewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_address = @"";
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
	
	_executeHouseValuesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self);
		return [self houseValuesSignal];
	}];
	
	_executeMarryValuesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self);
		return [self marryValuesSignal];
	}];
	return self;
}

- (void)getLocationCoordinate:(CLLocationCoordinate2D)coordinate {
  [[self.services fetchLocationWithLatitude:coordinate.latitude longitude:coordinate.longitude]
   subscribeNext:^(MSFLocationModel *model) {
     if (self.addressViewModel.isStopAutoLocation) {
       return;
     }
		 if (self.address.length > 0) {
			return;
		 }
     //NSLog(@"%@",model);
     NSString *path = [[NSBundle mainBundle] pathForResource:@"dicareas" ofType:@"db"];
     FMDatabase *fmdb = [FMDatabase databaseWithPath:path];
     [fmdb open];
     NSError *error ;
     //NSMutableArray *regions = [NSMutableArray array];
     FMResultSet *sProvince = [fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where area_name = '%@' and parent_area_code = '000000'", model.result.addressComponent.province]];
		 if ([sProvince next]) {
			 MSFAreas *areaProvince = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:sProvince error:&error];
			 if (![self.model.currentProvinceCode isEqualToString:areaProvince.codeID]) {
				 self.addressViewModel.province  = areaProvince;
			 }
			 
			 FMResultSet *sCity = [fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where area_name = '%@' and parent_area_code = '%@'", model.result.addressComponent.city, areaProvince.codeID]];
			 if ([sCity next]) {
				 MSFAreas *areaCity = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:sCity error:&error];
				 if (![self.model.currentCityCode isEqualToString:areaCity.codeID]) {
					 self.addressViewModel.city = areaCity;
				 }
				 //self.addressViewModel.city = areaCity;
				 FMResultSet *sArea = [fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where area_name = '%@' and parent_area_code = '%@'", model.result.addressComponent.city, areaCity.codeID]];
				 if ([sArea next]) {
					 MSFAreas *area = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:sArea error:&error];
					 if (![self.model.currentCountryCode isEqualToString:area.codeID]) {
						 self.addressViewModel.area  = area;
					 }
					 
				 } else {
					 [self setAreaEmpty];
				 }
			 } else {
				 [self setCityEmpty];
				 [self setAreaEmpty];
			 }
		 } else {
			 [self setProvinceEmpty];
			 [self setCityEmpty];
			 [self setAreaEmpty];
		 }
		 
   }
   error:^(NSError *error) {
     NSLog(@"%@", error);
   }];
}

#pragma mark - Private

- (RACSignal *)commitSignal {
	NSString *error = [self checkForm];
	if (error) {
		return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: error,
		}]];
	}
	
	return [self.formsViewModel submitUserInfo];
	//return [self.formsViewModel submitSignalWithPage:2];
}

- (NSString *)checkForm {
	if (![self.model.email containsString:@"@"] || ![self.model.email containsString:@"."]) {
		return @"请填写正确的邮箱";
	}
	if (self.model.currentProvinceCode.length == 0) {
		return @"请选择完整的现居地址";
	}
	if (self.model.currentCityCode.length == 0) {
		return @"请选择完整的现居地址";
	}
	if (self.model.currentCountryCode.length == 0) {
		return @"请选择完整的现居地址";
	}
	if (self.model.abodeDetail.length < 3) {
		return @"请填写完整的详细地址";
	}
	if (self.model.houseType.length == 0) {
		return @"请选择住房状况";
	}
	NSString *homelineInfo = [self checkHomeline:self.model.homeLine];
	if (homelineInfo) {
		return homelineInfo;
	}
	if (self.model.maritalStatus.length == 0) {
		return @"请选择婚姻状况";
	}
	
	
	
	
	/*

	if ([self.model.income isEqualToString:@""]) {
		return @"请输入每月税前收入";
	}
	if ([self.model.familyExpense isEqualToString:@""]) {
		return @"请输入每月还贷额";
	}
	if ([self.model.otherIncome isEqualToString:@""]) {
		return @"请输入月其他收入";
	}
	if (self.model.homeCode.length != 0 || self.model.homeLine.length != 0) {
		if (self.model.homeCode.length < 3 || ![self.model.homeCode isScalar]) {
			return @"请输入正确的住宅座机区号";
		}
		if (self.model.homeLine.length == 0) {
			return @"请填写完住宅电话";
		}
		if (![[self.model.homeCode stringByAppendingString:self.model.homeLine] isTelephone]) {
			return @"请输正确的住宅电话";
		}
	}
	if (![self.model.email isMail]) {
		return @"请输正确的邮箱";
	}
	if (![self validAddress]) {
		return @"详细地址至少输入两项";
	}*/
	if (self.model.qq.length > 0 && (self.model.qq.length < 5 || self.model.qq.length > 10)) {
		return @"请输入正确的QQ号";
	}
	
	//self.model.taobaoPassword = self.model.taobaoPassword.length > 0 ? @"Y" : @"N";
	//self.model.jdAccountPwd = self.model.jdAccountPwd.length > 0 ? @"Y" : @"N";
	return nil;
}

- (NSString *)checkHomeline:(NSString *)homeLine {
	NSArray *components = [homeLine componentsSeparatedByString:@"-"];
	if (components.count != 2) {
		return @"请输入正确的座机号";
	} else {
		if ([components[0] length] < 3 || [components[1] length] < 7) {
			return @"请输入正确的座机号";
		}
	}
	return nil;
}

/*
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
}*/

- (RACSignal *)houseValuesSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"housing_conditions"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(MSFSelectKeyValues *x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.model.houseTypeTitle = x.text;
			self.model.houseType = x.code;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (RACSignal *)marryValuesSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"marital_status"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(MSFSelectKeyValues *x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.model.marriageTitle = x.text;
			self.model.maritalStatus = x.code;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (void)setProvinceEmpty {
	self.addressViewModel.province.name = @"";
	self.addressViewModel.province.codeID = @"";
	self.addressViewModel.province.parentCodeID = @"";
	self.addressViewModel.provinceName = @"";
	self.addressViewModel.provinceCode = @"";
}

- (void)setCityEmpty {
	self.addressViewModel.city.name = @"";
	self.addressViewModel.city.codeID  = @"";
	self.addressViewModel.city.parentCodeID = @"";
	self.addressViewModel.cityName = @"";
	self.addressViewModel.cityCode = @"";
}

- (void)setAreaEmpty {
	self.addressViewModel.area.name  = @"";
	self.addressViewModel.area.codeID = @"";
	self.addressViewModel.area.parentCodeID = @"";
	self.addressViewModel.areaCode = @"";
	self.addressViewModel.areaName = @"";
}

@end
