//
// MSFTabBarViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTabBarViewModel.h"

QuickSpecBegin(MSFTabBarViewModelSpec)

__block MSFTabBarViewModel *viewModel;
__block id <MSFViewModelServices> services;

beforeEach(^{
	services = mockProtocol(@protocol(MSFViewModelServices));
	viewModel = [[MSFTabBarViewModel alloc] initWithServices:services];
	expect(viewModel).notTo(beNil());
});

it(@"should initialize", ^{
  // then
	expect(viewModel.services).to(equal(services));
	expect(viewModel.formsViewModel).notTo(beNil());
	expect(viewModel.authorizeViewModel).notTo(beNil());
	expect(viewModel.authorizationUpdatedSignal).notTo(beNil());
});

QuickSpecEnd
