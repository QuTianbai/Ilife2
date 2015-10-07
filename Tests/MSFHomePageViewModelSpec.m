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
  MSFLoanViewModel *sub = [viewModel viewModelForIndexPath:indexPath];
  NSString *reusableIdentifier = [viewModel reusableIdentifierForIndexPath:indexPath];
  
  // then
  expect(sub).to(beNil());
  expect(reusableIdentifier).to(equal(@"MSFHomePageContentCollectionViewCell"));
});

//TODO: 暂时不考虑这里的状态
xit(@"should has a appling viewmodel", ^{
  // given
	MSFClient *client = mock([MSFClient class]);
	[given([services httpClient]) willReturn:client];
	
	[given([client isAuthenticated]) willReturn:@YES];
	[given([client checkUserHasCredit]) willDo:^id(NSInvocation *invocation) {
		NSDictionary *representation = @{
			@"data" : @{
				@"status" : @"1",
				@"apply_time" : @"2015-08-12T15:30:37Z",
				@"total_amount" : @"0.00",
				@"total_installments" : @"0",
				@"monthly_repayment_amount" : @"0.00"
			},
			@"processing" : @"1"
		};
		MSFResponse *response = [[MSFResponse alloc] initWithHTTPURLResponse:nil parsedResult:representation];
		return [RACSignal return:response];
	}];
	
  // when
  [[viewModel.refreshCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	
  // then
  NSIndexPath *indexPah = mock(NSIndexPath.class);
  stubProperty(indexPah, item, 0);
  MSFLoanViewModel *sub = [viewModel viewModelForIndexPath:indexPah];
	
  expect(sub.status).to(equal(@"审核中"));
  expect([viewModel reusableIdentifierForIndexPath:indexPah]).to(equal(@"MSFHomePageContentCollectionViewCell"));
});

QuickSpecEnd
