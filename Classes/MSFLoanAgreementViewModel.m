//
// MSFLoanAgreementViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoanAgreementViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFApplicationResponse.h"
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFAddressCodes.h"
#import "MSFApplyCashViewModel.h"
#import "MSFClient+Agreements.h"
#import "MSFSocialInsuranceCashViewModel.h"
#import "MSFClient+SocialInsurance.h"
#import "MSFLoanType.h"
#import "MSFCommodityCashViewModel.h"
#import "MSFDistinguishViewModel.h"
#import "MSFCartViewModel.h"
#import "MSFFaceMaskViewModel.h"
#import "MSFFaceMaskPhtoViewController.h"

@implementation MSFLoanAgreementViewModel

- (instancetype)initWithApplicationViewModel:(id <MSFApplicationViewModel>)applicationViewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_applicationViewModel = applicationViewModel;
	_services = self.applicationViewModel.services;
	
	@weakify(self)
	_executeAcceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return self.executeAcceptSignal;
	}];
	
	return self;
}

- (RACSignal *)loanAgreementSignal {
	if ([self.applicationViewModel isKindOfClass:MSFApplyCashViewModel.class]) {
		return [self.services.httpClient fetchLoanAgreementWithProduct:self.applicationViewModel];
	} else if ([self.applicationViewModel isKindOfClass:MSFSocialInsuranceCashViewModel.class]) {
		return [self.services.httpClient fetchLifeLoanAgreement:self.applicationViewModel.loanType.typeID];
	} else if ([self.applicationViewModel isKindOfClass:MSFCartViewModel.class]) {
		return [self.services.httpClient fetchCommodityLoanAgreement:self.applicationViewModel];
	}
	return [RACSignal empty];
}

- (RACSignal *)executeAcceptSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		if ([self.applicationViewModel isKindOfClass:MSFCartViewModel.class]) {
			[self.services pushViewModel:self.applicationViewModel];
		}
		[subscriber sendCompleted];
		return [RACDisposable disposableWithBlock:^{
		}];
	}];
}

@end
