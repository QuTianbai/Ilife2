//
// MSFLoanAgreementViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoanAgreementViewModel.h"
#import "MSFProduct.h"
#import "MSFFormsViewModel.h"
#import "MSFApplicationResponse.h"

QuickSpecBegin(MSFLoanAgreementViewModelSpec)

__block MSFLoanAgreementViewModel *viewModel;
__block MSFProduct *product;
__block MSFFormsViewModel *formsViewModel;

beforeEach(^{
	id <MSFViewModelServices> services = mockProtocol(@protocol(MSFViewModelServices));
	product = mock([MSFProduct class]);
	formsViewModel = mock([MSFFormsViewModel class]);
	[given([formsViewModel services]) willReturn:services];
	
	viewModel = [[MSFLoanAgreementViewModel alloc] initWithFromsViewModel:formsViewModel product:product];
});

it(@"should initialize", ^{
  // then
	expect(viewModel).notTo(beNil());
	expect(viewModel.product).to(equal(product));
	expect(viewModel.formsViewModel).to(equal(formsViewModel));
	expect(viewModel.services).to(equal(formsViewModel.services));
	expect(viewModel.agreementViewModel).notTo(beNil());
});

QuickSpecEnd
