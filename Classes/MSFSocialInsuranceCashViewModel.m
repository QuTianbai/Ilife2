//
//  MSFSocialInsuranceCashViewModel.m
//  Finance
//
//  Created by xbm on 15/11/20.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSocialInsuranceCashViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFAddressViewModel.h"
#import "MSFAddressCodes.h"
#import "MSFContact.h"
#import "MSFUser.h"
#import "MSFPersonal.h"
#import "MSFClient+Users.h"
#import "MSFSocialInsurance.h"
#import "MSFSelectKeyValues.h"
#import "MSFLoanType.h"

@interface MSFSocialInsuranceCashViewModel()

@property (nonatomic, copy) MSFPersonal *personal;
@property (nonatomic, copy) NSArray *contacts;
@property (nonatomic, strong) MSFContact *firstContact;
@property (nonatomic, strong) MSFAddressViewModel *addressViewModel;
@property (nonatomic, strong) NSString *purposeCode; // 贷款用途
@property (nonatomic, strong) NSString *radixCode; // 保险基数

@end

@implementation MSFSocialInsuranceCashViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	
	MSFUser *user = self.services.httpClient.user;
	self.personal = user.personal;
	self.contacts = user.contacts;
	self.firstContact = user.contacts.firstObject;
	
	MSFAddressCodes *addressModel = [MSFAddressCodes modelWithDictionary:@{
		@"province" : self.personal.abodeStateCode ?: @"",
		@"city" : self.personal.abodeCityCode ?: @"",
		@"area" : self.personal.abodeZoneCode ?: @""
	} error:nil];
	_addressViewModel = [[MSFAddressViewModel alloc] initWithAddress:addressModel services:self.services];
	RAC(self, personal.abodeStateCode) = RACObserve(self.addressViewModel, provinceCode);
	RAC(self, personal.abodeCityCode) = RACObserve(self.addressViewModel, cityCode);
	RAC(self, personal.abodeZoneCode) = RACObserve(self.addressViewModel, areaCode);
	RAC(self, address) = RACObserve(self.addressViewModel, address);
	RACChannelTo(self, detailAddress) = RACChannelTo(self.personal, abodeDetail);
	RACChannelTo(self, contactName) = RACChannelTo(self.firstContact, contactName);
	RACChannelTo(self, contactPhone) = RACChannelTo(self.firstContact, contactMobile);
	
	_executePurposeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [[self.services msf_selectKeyValuesWithContent:@"moneyUse"] doNext:^(MSFSelectKeyValues *x) {
			self.purposeCode = x.code;
		}];
	}];
	RAC(self, purposeTitle) = [RACObserve(self, purposeCode) flattenMap:^RACStream *(id value) {
		return [self.services msf_selectValuesWithContent:@"moneyUse" keycode:value];
	}];
	
	_executeBasicPaymentCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [[self.services msf_selectKeyValuesWithContent:@"employeeOlderInsurance"] doNext:^(MSFSelectKeyValues *x) {
			self.radixCode = x.code;
		}];
	}];
	RAC(self, radixTitle) = [RACObserve(self, radixCode) flattenMap:^RACStream *(id value) {
		return [self.services msf_selectValuesWithContent:@"employeeOlderInsurance" keycode:value];
	}];
	
	_executeSubmitCommand = [[RACCommand alloc] initWithEnabled:[self submitValidSignal] signalBlock:^RACSignal *(id input) {
		return [self submitSignal];
	}];
	_executeCommitCommand = _executeSubmitCommand;
	
	return self;
}

- (RACSignal *)submitValidSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self, purposeCode),
		RACObserve(self, address),
		RACObserve(self, detailAddress),
		RACObserve(self, contactName),
		RACObserve(self, contactPhone),
		RACObserve(self, radixCode),
	]
	reduce:^id(NSString *purpose, NSString *address, NSString *detail, NSString *name, NSString *phone, NSString *code){
		return @(purpose.length > 0 && address.length > 0 && detail.length > 0 && name.length > 0 && phone.length > 0 && code.length > 0);
	}];
}

- (RACSignal *)submitSignal {
	return [[self updateSignal] combineLatestWith:[self commitSignal]];
}

- (RACSignal *)updateSignal {
	MSFUser *user = [self.services.httpClient.user copy];
	MSFSocialInsurance *insurance = [[MSFSocialInsurance alloc] initWithDictionary:@{
		@keypath(MSFSocialInsurance.new, empEdwBase): self.radixCode
	} error:nil];
	MSFUser *model = [[MSFUser alloc] initWithDictionary:@{
		@keypath(MSFUser.new, personal): self.personal,
		@keypath(MSFUser.new, contacts): self.contacts,
		@keypath(MSFUser.new, insurance): insurance,
	} error:nil];
	[user mergeValueForKey:@keypath(user.personal) fromModel:model];
	[user mergeValueForKey:@keypath(user.contacts) fromModel:model];
	return [[self.services.httpClient updateUser:user] doNext:^(id x) {
		[self.services.httpClient.user mergeValueForKey:@keypath(MSFUser.new, personal) fromModel:model];
		[self.services.httpClient.user mergeValueForKey:@keypath(MSFUser.new, contacts) fromModel:model];
	}];
}

- (RACSignal *)commitSignal {
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
	parameters[@"productCd"] = @4102;
	parameters[@"loanPurpose"] = self.purposeCode?:@"";
	parameters[@"jionLifeInsurance"] = self.joinInsurance ? @"1" : @"0";
	NSURLRequest *request = [self.services.httpClient requestWithMethod:@"POST" path:@"loan/limit" parameters:@{
		@"applyVO": [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding]
	}];
	return [self.services.httpClient enqueueRequest:request resultClass:nil];
}

#pragma mark - Custom Accessors

- (MSFLoanType *)loanType {
	return [[MSFLoanType alloc] initWithTypeID:@"4102"];
}

@end
