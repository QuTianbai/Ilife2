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
#import "MSFUserViewModel.h"
#import "MSFUser.h"
#import "MSFClient+Users.h"
#import "MSFClient.h"
#import "MSFPersonal.h"

@interface MSFPersonalViewModel ()

@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, strong) MSFAddressViewModel *addressViewModel;
@property (nonatomic, strong) MSFPersonal *model;

@property (nonatomic, strong) MSFFormsViewModel *formsViewModel DEPRECATED_ATTRIBUTE;
@property (nonatomic, strong, readwrite) MSFApplicationForms *forms DEPRECATED_ATTRIBUTE;
@property (nonatomic, assign) NSUInteger modelHash DEPRECATED_ATTRIBUTE;

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
	MSFAddress *addrModel = [MSFAddress modelWithDictionary:addr error:nil];
	_addressViewModel = [[MSFAddressViewModel alloc] initWithAddress:addrModel services:_services];
	_address = _addressViewModel.address;
	RAC(self, model.abodeStateCode) = RACObserve(self.addressViewModel, provinceCode);
	RAC(self, model.abodeCityCode) = RACObserve(self.addressViewModel, cityCode);
	RAC(self, model.abodeZoneCode) = RACObserve(self.addressViewModel, areaCode);
	
	RAC(self, address) = RACObserve(self.addressViewModel, address);
	RACChannelTo(self, detailAddress) = RACChannelTo(self.model, abodeDetail);
	RACChannelTo(self, email) = RACChannelTo(self.model, email);
	RACChannelTo(self, phone) = RACChannelTo(self.model, homePhone);

	NSArray *houseTypes = [MSFSelectKeyValues getSelectKeys:@"housing_conditions"];
	[houseTypes enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.houseCondition]) {
			self.house = obj.text;
			*stop = YES;
		}
	}];
	NSArray *marriageStatus = [MSFSelectKeyValues getSelectKeys:@"marital_status"];
	[marriageStatus enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
		if ([obj.code isEqualToString:self.model.maritalStatus]) {
			self.marriage = obj.text;
			*stop = YES;
		}
	}];

	@weakify(self)
	_executeAlterAddressCommand = self.addressViewModel.selectCommand;
	_executeHouseValuesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self);
		return [self houseValuesSignal];
	}];
	_executeHouseValuesCommand.allowsConcurrentExecution = YES;
	

	_executeCommitCommand = [[RACCommand alloc] initWithEnabled:[self updateValidSignal] signalBlock:^RACSignal *(id input) {
		return [self updateSignal];
	}];
	
	return self;
}

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)viewModel {
	self = [super init];
	if (!self) {
		return nil;
	}

	return self;
}

#pragma mark - Private

- (RACSignal *)updateValidSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self, house),
		RACObserve(self, email),
		RACObserve(self, phone),
		RACObserve(self, address),
		RACObserve(self, detailAddress),
	]
	reduce:^id(NSString *condition, NSString *email, NSString *phone, NSString *address, NSString *detail){
		return @(condition.length > 0 && email.length > 0 && phone.length > 0 && address.length > 0 && detail.length > 0);
	}];
}

- (RACSignal *)updateSignal {
	return [[self.services.httpClient fetchUserInfo] flattenMap:^RACStream *(MSFUser *value) {
		MSFUser *model = [[MSFUser alloc] initWithDictionary:@{@keypath(MSFUser.new, personal): self.model} error:nil];
		[value mergeValueForKey:@keypath(MSFUser.new, personal) fromModel:model];
		return [[self.services.httpClient updateUser:value] doNext:^(id x) {
			[self.services.httpClient.user mergeValueForKey:@keypath(value.personal) fromModel:model];
		}];
	}];
}

- (RACSignal *)houseValuesSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectKeyValuesViewModel:[MSFSelectKeyValues getSelectKeys:@"housing_conditions"]];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(MSFSelectKeyValues *x) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
			self.model.houseCondition = x.code;
			self.house = x.text;
			[self.services popViewModel];
		}];
		return nil;
	}];
}

@end
