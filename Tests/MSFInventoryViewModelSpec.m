//
// MSFInventoryViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFInventoryViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFViewModelServices.h"
#import "MSFClient.h"
#import "MSFClient+Elements.h"
#import "MSFProduct.h"
#import "MSFElement.h"
#import "MSFFormsViewModel.h"
#import "MSFApplicationForms.h"

QuickSpecBegin(MSFInventoryViewModelSpec)

__block MSFInventoryViewModel *viewModel;
__block id <MSFViewModelServices> services;
__block MSFClient *client;
__block MSFFormsViewModel *formsViewModel;
__block MSFApplicationForms *form;

beforeEach(^{
	client = mock(MSFClient.class);
	services = mockProtocol(@protocol(MSFViewModelServices));
	[given([services httpClient]) willReturn:client];
	
	form = mock(MSFApplicationForms.class);
	stubProperty(form, productId, @"102");
	stubProperty(form, applyNo, @"10000");
	
	formsViewModel = mock(MSFFormsViewModel.class);
	stubProperty(formsViewModel, model, form);
	[given([formsViewModel services]) willReturn:services];
	
	viewModel = [[MSFInventoryViewModel alloc] initWithFormsViewModel:formsViewModel];
	expect(viewModel).notTo(beNil());
});

it(@"should initialize", ^{
	// then
	expect(viewModel.model).notTo(beNil());
	expect(viewModel.product).notTo(beNil());
	expect(viewModel.credit).notTo(beNil());
});

QuickSpecEnd
