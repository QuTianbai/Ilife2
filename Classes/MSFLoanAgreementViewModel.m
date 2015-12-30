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
#import "MSFAddress.h"
#import "MSFApplyCashVIewModel.h"
#import "MSFClient+Agreements.h"
#import "MSFSocialInsuranceCashViewModel.h"
#import "MSFClient+MSFSocialInsurance.h"
#import "MSFLoanType.h"
#import "MSFCommodityCashViewModel.h"
#import "MSFDistinguishViewModel.h"
#import "MSFCommoditesViewModel.h"
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
	_executeRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		if ([self.applicationViewModel isKindOfClass:MSFApplyCashVIewModel.class]) {
			return [(MSFApplyCashVIewModel *)self.applicationViewModel submitSignalWithStatus:@"0"];
		}
		return RACSignal.empty;
	}];
	
	_executeAcceptCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return self.executeAcceptSignal;
	}];
	
	return self;
}

- (RACSignal *)loanAgreementSignal {
	if ([self.applicationViewModel isKindOfClass:MSFApplyCashVIewModel.class]) {
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
		} else {
			MSFFaceMaskViewModel *viewModel = [[MSFFaceMaskViewModel alloc] initWithApplicationViewModel:self.applicationViewModel];
			[self.services pushViewModel:viewModel];
		}
		[subscriber sendCompleted];
		return [RACDisposable disposableWithBlock:^{
		}];
	}];
}

@end
