//
// MSFBannersViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFBannersViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient.h"
#import "MSFClient+Advers.h"
#import "MSFResponse.h"
#import "MSFAdver.h"

QuickSpecBegin(MSFBannersViewModelSpec)

__block MSFBannersViewModel *viewModel;

beforeEach(^{
	id <MSFViewModelServices> servcies = mockProtocol(@protocol(MSFViewModelServices));
  viewModel = [[MSFBannersViewModel alloc] initWithServices:servcies];
});

it(@"should initialize", ^{
  // then
  expect(viewModel).notTo(beNil());
});

it(@"should return number of section", ^{
  // then
  expect(@(viewModel.numberOfSections)).to(equal(@1));
});

QuickSpecEnd
