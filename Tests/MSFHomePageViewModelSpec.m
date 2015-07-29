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

QuickSpecBegin(MSFHomePageViewModelSpec)

__block MSFHomepageViewModel *viewModel;
__block id <MSFViewModelServices> services;

beforeEach(^{
	services = mockProtocol(@protocol(MSFViewModelServices));
  viewModel = [[MSFHomepageViewModel alloc] initWithServices:services];
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
	MSFClient *client = mock([MSFClient class]);
	[given([services httpClient]) willReturn:client];
	
	[given([client isAuthenticated]) willReturn:@YES];
	[given([client fetchApplyList]) willDo:^id(NSInvocation *invocation) {
		MSFApplyList *model = [[MSFApplyList alloc] initWithDictionary:@{
			@"loan_id": @"1dafds782nj2",
			@"apply_time": @"2015-05-03T15:38:45Z",
			@"payed_amount": @"200",
			@"total_amount": @"300",
			@"monthly_repayment_amount": @"400",
			@"current_installment": @4,
			@"total_installments": @10,
			@"status": @0
		} error:nil];
		return [RACSignal return:model];
	}];
	
  // when
  [[viewModel.refreshCommand execute:nil] asynchronousFirstOrDefault:nil success:nil error:nil];
	
  // then
  NSIndexPath *indexPah = mock(NSIndexPath.class);
  stubProperty(indexPah, item, 0);
  MSFLoanViewModel *sub = [viewModel viewModelForIndexPath:indexPah];
	
  expect(sub.status).to(equal(@"无效"));
  expect([viewModel reusableIdentifierForIndexPath:indexPah]).to(equal(@"MSFApplyCollectionViewCell"));
});

QuickSpecEnd
