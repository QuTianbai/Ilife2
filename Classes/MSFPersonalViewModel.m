//
// MSFBasicViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFPersonalViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <CoreLocation/CoreLocation.h>
#import <FMDB/FMDB.h>

#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFAddressViewModel.h"
#import "MSFLocationModel.h"
#import "MSFResultModel.h"
#import "MSFSelectionViewModel.h"
#import "RCLocationManager.h"
#import "MSFSelectKeyValues.h"

#import "MSFAreas.h"
#import "MSFAddress.h"
#import "MSFAddressInfo.h"
#import "NSString+Matches.h"
#import "NSURLConnection+Locations.h"

@interface MSFPersonalViewModel ()

@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, strong) MSFFormsViewModel *formsViewModel;
@property (nonatomic, strong, readwrite) MSFApplicationForms *forms;
@property (nonatomic, strong) MSFAddressViewModel *addrViewModel;
@property (nonatomic, assign) NSUInteger modelHash;

@end

@implementation MSFPersonalViewModel

#pragma mark - Lifecycle

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)viewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = viewModel.services;
	_forms = viewModel.model.copy;
	_formsViewModel = viewModel;
	NSDictionary *addr = @{@"province" : viewModel.model.currentProvinceCode ?: @"",
												 @"city" : viewModel.model.currentCityCode ?: @"",
												 @"area" : viewModel.model.currentCountryCode ?: @""};
	MSFAddress *addrModel = [MSFAddress modelWithDictionary:addr error:nil];
	_addrViewModel = [[MSFAddressViewModel alloc] initWithAddress:addrModel services:_services];
	_address = _addrViewModel.address;
	
	BOOL validCoor = CLLocationCoordinate2DIsValid([RCLocationManager sharedManager].location.coordinate);
	BOOL existAddr = _address.length > 0;
	if (validCoor && !existAddr) {
		[self getLocationCoordinate:[RCLocationManager sharedManager].location.coordinate];
	}
	
	RAC(self, address) = RACObserve(self.addrViewModel, address);
	RAC(self, forms.currentProvinceCode) = RACObserve(self.addrViewModel, provinceCode);
	RAC(self, forms.currentCityCode) = RACObserve(self.addrViewModel, cityCode);
	RAC(self, forms.currentCountryCode) = RACObserve(self.addrViewModel, areaCode);
	
	NSArray *houseTypes = [MSFSelectKeyValues getSelectKeys:@"housing_conditions"];
	[houseTypes enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.forms.houseType]) {
			self.forms.houseTypeTitle = obj.text;
			*stop = YES;
		}
	}];
	NSArray *marriageStatus = [MSFSelectKeyValues getSelectKeys:@"marital_status"];
	[marriageStatus enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.forms.maritalStatus]) {
			self.forms.marriageTitle = obj.text;
			*stop = YES;
		}
	}];
	
	@weakify(self)
	_executeAlterAddressCommand = self.addrViewModel.selectCommand;
  _executeCommitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    @strongify(self);
    return [self commitSignal];
  }];
	_executeHouseValuesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self);
		return [self houseValuesSignal];
	}];
	_executeHouseValuesCommand.allowsConcurrentExecution = YES;
	
	_modelHash = _forms.hash;
	
	return self;
}

- (BOOL)edited {
	NSUInteger newHash = _forms.hash;
	return newHash != _modelHash;
}

#pragma mark - Private

- (RACSignal *)commitSignal {
	NSString *error = [self checkForm];
	if (error) {
		return [RACSignal error:[NSError errorWithDomain:@"MSFPersonalViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: error,
		}]];
	}
	[self.formsViewModel.model mergeValuesForKeysFromModel:self.forms];
	return [self.formsViewModel submitUserInfoType:1];
}

- (NSString *)checkForm {
	MSFApplicationForms *forms = self.forms;
	
	if (forms.houseType.length == 0) {
		return @"请选择住房状况";
	}
	if (forms.email.length > 0 && ([forms.email rangeOfString:@"@"].location == NSNotFound || [forms.email rangeOfString:@"."].location == NSNotFound)) {
		return @"请填写正确的邮箱";
	}
	if (forms.homeCode.length > 0 || forms.homeLine.length > 0) {
		if (forms.homeCode.length < 3 || ![forms.homeCode isScalar]) {
			return @"请填写正确的住宅座机号";
		}
		if (forms.homeLine.length < 7 || ![forms.homeCode isScalar]) {
			return @"请填写正确的住宅座机号";
		}
	}
	if (forms.currentProvinceCode.length == 0) {
		return @"请选择完整的现居地址";
	}
	if (forms.currentCityCode.length == 0) {
		return @"请选择完整的现居地址";
	}
	if (forms.currentCountryCode.length == 0) {
		return @"请选择完整的现居地址";
	}
	if (forms.abodeDetail.length < 3) {
		return @"请填写完整的详细地址";
	}
	if (forms.qq.length > 0 && (forms.qq.length < 5 || forms.qq.length > 10)) {
		return @"请输入正确的QQ号";
	}
	return nil;
}

- (RACSignal *)houseValuesSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"housing_conditions"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(MSFSelectKeyValues *x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.forms.houseTypeTitle = x.text;
			self.forms.houseType = x.code;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

- (void)getLocationCoordinate:(CLLocationCoordinate2D)coordinate {
	[[NSURLConnection fetchLocationWithLatitude:coordinate.latitude longitude:coordinate.longitude]
	 subscribeNext:^(MSFLocationModel *model) {
		 if (self.addrViewModel.isStopAutoLocation) {
			 return;
		 }
		 if (self.address.length > 0) {
			 return;
		 }
		 
		 NSString *path = [[NSBundle mainBundle] pathForResource:@"dicareas" ofType:@"db"];
		 FMDatabase *fmdb = [FMDatabase databaseWithPath:path];
		 [fmdb open];
		 NSError *error ;
		 FMResultSet *sProvince = [fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where area_name = '%@' and parent_area_code = '000000'", model.result.addressComponent.province]];
		 if ([sProvince next]) {
			 MSFAreas *areaProvince = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:sProvince error:&error];
			 if (![self.forms.currentProvinceCode isEqualToString:areaProvince.codeID]) {
				 self.addrViewModel.province  = areaProvince;
			 }
			 
			 FMResultSet *sCity = [fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where area_name = '%@' and parent_area_code = '%@'", model.result.addressComponent.city, areaProvince.codeID]];
			 if ([sCity next]) {
				 MSFAreas *areaCity = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:sCity error:&error];
				 if (![self.formsViewModel.model.currentCityCode isEqualToString:areaCity.codeID]) {
					 self.addrViewModel.city = areaCity;
				 }
				 FMResultSet *sArea = [fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where area_name = '%@' and parent_area_code = '%@'", model.result.addressComponent.city, areaCity.codeID]];
				 if ([sArea next]) {
					 MSFAreas *area = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:sArea error:&error];
					 if (![self.formsViewModel.model.currentCountryCode isEqualToString:area.codeID]) {
						 self.addrViewModel.area  = area;
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

- (void)setProvinceEmpty {
	self.addrViewModel.province.name = @"";
	self.addrViewModel.province.codeID = @"";
	self.addrViewModel.province.parentCodeID = @"";
	self.addrViewModel.provinceName = @"";
	self.addrViewModel.provinceCode = @"";
}

- (void)setCityEmpty {
	self.addrViewModel.city.name = @"";
	self.addrViewModel.city.codeID  = @"";
	self.addrViewModel.city.parentCodeID = @"";
	self.addrViewModel.cityName = @"";
	self.addrViewModel.cityCode = @"";
}

- (void)setAreaEmpty {
	self.addrViewModel.area.name  = @"";
	self.addrViewModel.area.codeID = @"";
	self.addrViewModel.area.parentCodeID = @"";
	self.addrViewModel.areaCode = @"";
	self.addrViewModel.areaName = @"";
}

@end
