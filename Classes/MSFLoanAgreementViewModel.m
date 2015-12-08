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
	
	return self;
}

- (RACSignal *)loanAgreementSignal {
	if ([self.applicationViewModel isKindOfClass:MSFApplyCashVIewModel.class]) {
		return [self.services.httpClient fetchLoanAgreementWithProduct:self.applicationViewModel];
	}
	if ([self.applicationViewModel isKindOfClass:MSFSocialInsuranceCashViewModel.class]) {
		return [self.services.httpClient fetchLifeLoanAgreement:self.applicationViewModel.loanType.typeID];
	}
	return [RACSignal empty];
}

@end
