//
// MSFBasicViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFPersonalViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <FMDB/FMDB.h>
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFAddressViewModel.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectKeyValues.h"
#import "MSFAddress.h"
#import "NSString+Matches.h"

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
	NSDictionary *addr = @{@"province" : _forms.currentProvinceCode ?: @"",
												 @"city" : _forms.currentCityCode ?: @"",
												 @"area" : _forms.currentCountryCode ?: @""};
	MSFAddress *addrModel = [MSFAddress modelWithDictionary:addr error:nil];
	_addrViewModel = [[MSFAddressViewModel alloc] initWithAddress:addrModel services:_services];
	_address = _addrViewModel.address;

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

@end
