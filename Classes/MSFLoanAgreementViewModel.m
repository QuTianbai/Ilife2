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
#import "MSFAgreementViewModel.h"

@implementation MSFLoanAgreementViewModel

- (instancetype)initWithFromsViewModel:(MSFFormsViewModel *)formsViewModel product:(MSFProduct *)product {
	self = [super init];
	if (!self) {
		return nil;
	}
	_agreementViewModel = [[MSFAgreementViewModel alloc] initWithServices:formsViewModel.services];
	_formsViewModel = formsViewModel;
	_product = product;
	_services = formsViewModel.services;
	@weakify(self)
	_executeRequest = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self.formsViewModel submitSignalWithPage:1];
	}];
	
	return self;
}

@end
