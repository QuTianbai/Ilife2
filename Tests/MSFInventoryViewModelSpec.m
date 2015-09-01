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

QuickSpecBegin(MSFInventoryViewModelSpec)

__block MSFInventoryViewModel *viewModel;
__block id <MSFViewModelServices> services;
__block MSFClient *client;
__block MSFFormsViewModel *formsViewModel;

beforeEach(^{
	client = mock(MSFClient.class);
	services = mockProtocol(@protocol(MSFViewModelServices));
	[given([services httpClient]) willReturn:client];
	
	formsViewModel = mock(MSFFormsViewModel.class);
	[given([formsViewModel services]) willReturn:services];
	
	viewModel = [[MSFInventoryViewModel alloc] initWithFormsViewModel:formsViewModel];
	expect(viewModel).notTo(beNil());
});

it(@"should initialize", ^{
	// then
	expect(viewModel.model).notTo(beNil());
});

QuickSpecEnd
