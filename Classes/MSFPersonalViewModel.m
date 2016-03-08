//
// MSFBasicViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFPersonalViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <FMDB/FMDB.h>
#import "MSFAddressViewModel.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectKeyValues.h"
#import "MSFAddressCodes.h"
#import "NSString+Matches.h"
#import "MSFUserViewModel.h"
#import "MSFUser.h"
#import "MSFClient+Users.h"
#import "MSFClient.h"
#import "MSFPersonal.h"

@interface MSFPersonalViewModel ()

@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, strong) MSFAddressViewModel *addressViewModel;
@property (nonatomic, strong) MSFPersonal *model;

@end

@implementation MSFPersonalViewModel

#pragma mark - Lifecycle

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_model = [[services httpClient].user.personal copy];
	
	NSDictionary *addr = @{
		@"province" : self.model.abodeStateCode ?: @"",
		@"city" : self.model.abodeCityCode ?: @"",
		@"area" : self.model.abodeZoneCode ?: @""
	};
	MSFAddressCodes *addrModel = [MSFAddressCodes modelWithDictionary:addr error:nil];
	_addressViewModel = [[MSFAddressViewModel alloc] initWithAddress:addrModel services:_services];
	_address = _addressViewModel.address;
	RAC(self, model.abodeStateCode) = RACObserve(self.addressViewModel, provinceCode);
	RAC(self, model.abodeCityCode) = RACObserve(self.addressViewModel, cityCode);
	RAC(self, model.abodeZoneCode) = RACObserve(self.addressViewModel, areaCode);
	
	RAC(self, address) = RACObserve(self.addressViewModel, address);
	RACChannelTo(self, detailAddress) = RACChannelTo(self.model, abodeDetail);
	RACChannelTo(self, email) = RACChannelTo(self.model, email);
	RACChannelTo(self, phone) = RACChannelTo(self.model, homePhone);

	@weakify(self)
	_executeAlterAddressCommand = self.addressViewModel.selectCommand;
	
	_executeHouseValuesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self);
		return [self.services msf_selectKeyValuesWithContent:@"housing_conditions"];
	}];
	RAC(self, house) = [RACObserve(self, model.houseCondition) flattenMap:^id(NSString *code) {
		return [self.services msf_selectValuesWithContent:@"housing_conditions" keycode:code];
	}];
	RAC(self, model.houseCondition) = [[self.executeHouseValuesCommand.executionSignals
		switchToLatest]
		map:^id(MSFSelectKeyValues *x) {
				return x.code;
		}];
	
	_executeCommitCommand = [[RACCommand alloc] initWithEnabled:[self updateValidSignal] signalBlock:^RACSignal *(id input) {
		return [self updateSignal];
	}];
	
	return self;
}

#pragma mark - Private

- (RACSignal *)updateValidSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self, house),
		RACObserve(self, email),
		RACObserve(self, address),
		RACObserve(self, detailAddress),
	]
	reduce:^id(NSString *condition, NSString *email, NSString *phone, NSString *address, NSString *detail){
		return @(condition.length > 0 && email.length > 0 && address.length > 0 && detail.length > 0);
	}];
}

- (RACSignal *)updateSignal {
	return [[self.services.httpClient fetchUserInfo] flattenMap:^RACStream *(MSFUser *value) {
		MSFUser *model = [[MSFUser alloc] initWithDictionary:@{@keypath(MSFUser.new, personal): self.model} error:nil];
		[value mergeValueForKey:@keypath(MSFUser.new, personal) fromModel:model];
		return [[self.services.httpClient updateUser:value] doNext:^(id x) {
			[self.services.httpClient.user mergeValueForKey:@keypath(MSFUser.new, personal) fromModel:model];
		}];
	}];
}

@end
