//
// MSFHomePageViewModelSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFHomepageViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFLoanViewModel.h"
#import "MSFClient.h"
#import "MSFApplyList.h"
#import "MSFClient+MSFApplyList.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "MSFUser.h"
#import "MSFServer.h"

QuickSpecBegin(MSFHomePageViewModelSpec)

__block MSFHomepageViewModel *viewModel;

beforeEach(^{
  viewModel = [[MSFHomepageViewModel alloc] init];
});

it(@"should initialize", ^{
  // then
  expect(@([viewModel numberOfItemsInSection:0])).to(equal(@1));
});

it(@"should not has viewmodel for placeholder", ^{
  // given
  NSIndexPath *indexPath = mock(NSIndexPath.class);
  
  // when
  MSFLoanViewModel *sub = [viewModel viewModelForIndexPath:indexPath];
  NSString *reusableIdentifier = [viewModel reusableIdentifierForIndexPath:indexPath];
  
  // then
  expect(sub).to(beNil());
  expect(reusableIdentifier).to(equal(@"MSFPlaceholderCollectionViewCell"));
});

it(@"should has a appling viewmodel", ^{
  // given
  [OHHTTPStubs addRequestHandler:^OHHTTPStubsResponse *(NSURLRequest *request, BOOL onlyCheck) {
    NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"applyList" withExtension:@"json"];
    return [OHHTTPStubsResponse responseWithFileURL:URL statusCode:200 responseTime:0 headers:@{@"Content-Type": @"application/json"}];
  }];
  NSIndexPath *indexPah = mock(NSIndexPath.class);
  stubProperty(indexPah, item, 0);
  MSFUser *user = mock(MSFUser.class);
  stubProperty(user, objectID, @"");
  stubProperty(user, server, MSFServer.dotComServer);
  MSFClient *client = [MSFClient authenticatedClientWithUser:user token:@"" session:@""];
  
  // when
  viewModel = [[MSFHomepageViewModel alloc] initWithClient:client];
  [[viewModel.refreshCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
  MSFLoanViewModel *sub = [viewModel viewModelForIndexPath:indexPah];
  
  // then
  expect(sub.status).to(equal(@"无效"));
  expect([viewModel reusableIdentifierForIndexPath:indexPah]).to(equal(@"MSFRequisitionCollectionViewCell"));
});

QuickSpecEnd
