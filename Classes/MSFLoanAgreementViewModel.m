//
// MSFLoanAgreementViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoanAgreementViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFApplicationResponse.h"
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"
#import "MSFAddress.h"
#import "MSFApplyCashVIewModel.h"
#import "MSFClient+Agreements.h"

@implementation MSFLoanAgreementViewModel

- (instancetype)initWithFromsViewModel:(MSFApplyCashVIewModel *)formsViewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_product = formsViewModel;
	_formsViewModel = formsViewModel;
	_services = formsViewModel.services;
	@weakify(self)
	_executeRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self.formsViewModel submitSignalWithStatus:@"0"];
	}];
	
	return self;
}

- (RACSignal *)loanAgreementSignal {
	return [self.services.httpClient fetchLoanAgreementWithProduct:self.formsViewModel];
}

@end
