//
// MSFHomePageViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHomepageViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFHomePageCellModel.h"
#import "MSFClient.h"
#import "MSFApplyList.h"
#import "MSFClient+ApplyList.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "MSFUser.h"
#import "MSFServer.h"
#import "MSFClient+Users.h"
#import "MSFResponse.h"

QuickSpecBegin(MSFHomePageViewModelSpec)

__block MSFHomepageViewModel *viewModel;
__block id <MSFViewModelServices> services;

beforeEach(^{
	services = mockProtocol(@protocol(MSFViewModelServices));
  viewModel = [[MSFHomepageViewModel alloc] initWithModel:nil services:services];
});

it(@"should initialize", ^{
  // then
  expect(@([viewModel numberOfItemsInSection:0])).to(equal(@1));
});

it(@"should not has viewmodel for placeholder", ^{
  // given
  NSIndexPath *indexPath = mock(NSIndexPath.class);
  
  // when
  MSFHomePageCellModel *sub = [viewModel viewModelForIndexPath:indexPath];
  NSString *reusableIdentifier = [viewModel reusableIdentifierForIndexPath:indexPath];
  
  // then
  expect(sub).to(beAKindOf([MSFHomepageViewModel class]));
  expect(reusableIdentifier).to(equal(@"MSFHomePageContentCollectionViewCell"));
});

QuickSpecEnd
