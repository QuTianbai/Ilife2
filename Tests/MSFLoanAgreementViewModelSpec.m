//
// MSFLoanAgreementViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoanAgreementViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFApplicationResponse.h"
#import "MSFApplyCashVIewModel.h"

QuickSpecBegin(MSFLoanAgreementViewModelSpec)

__block MSFLoanAgreementViewModel *viewModel;
__block MSFApplyCashViewModel *product;
__block id <MSFViewModelServices> services;

beforeEach(^{
	services = mockProtocol(@protocol(MSFViewModelServices));
	
	product = mock([MSFApplyCashViewModel class]);
	stubProperty(product, services, services);
	
	viewModel = [[MSFLoanAgreementViewModel alloc] initWithApplicationViewModel:product];
});

it(@"should initialize", ^{
  // then
	expect(viewModel).notTo(beNil());
	expect(viewModel.services).to(equal(services));
});

QuickSpecEnd
