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
#import "MSFClient.h"
#import "MSFClient+Order.h"
#import "MSFOrder.h"

QuickSpecBegin(MSFHomePageViewModelSpec)

__block MSFHomepageViewModel *viewModel;
__block id <MSFViewModelServices> services;
__block MSFClient *client;

NSDictionary *representation = @{
	@"count" : @100,
	@"pageSize" : @10,
	@"pageNo" : @0,
	@"orderList" : @[@{
		@"inOrderId" : @"1111111",
		@"totalAmt" : @10,
		@"totalQuantity" : @11,
		@"orderStatus" : @"11111",
		@"orderTime" : @1450503185106LL,
		@"cmdtyList" : @[@{
			@"catId" : @"111111",
			@"cmdtyId" : @"111111",
			@"brandName" : @"111111",
			@"cmdtyName" : @"111111",
			@"pcsCount" : @1,
			@"cmdtyPrice" : @1
		}]
	}]
};

beforeEach(^{
	services = mockProtocol(@protocol(MSFViewModelServices));
	client = mock([MSFClient class]);
	[given([services httpClient]) willReturn:client];
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

it(@"should has order that waiting for pay", ^{
	// given
	MSFOrder *order = [MTLJSONAdapter modelOfClass:MSFOrder.class fromJSONDictionary:representation error:nil];
	[given([client fetchOrderList:@"3" pageNo:0]) willReturn:[RACSignal return:order]];
	
	// when
	viewModel.active = YES;
	
	// then
	expect(@(viewModel.hasOrders)).to(beTruthy());
});

QuickSpecEnd
