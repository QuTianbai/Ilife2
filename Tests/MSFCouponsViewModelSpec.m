//
// MSFCouponsViewModelSpec.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCouponsViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCoupon.h"
#import "MSFCouponViewModel.h"
#import "MSFClient+Coupons.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

QuickSpecBegin(MSFCouponsViewModelSpec)

__block MSFCouponsViewModel *sut;
__block id <MSFViewModelServices> services;

it(@"should initialize", ^{
  // given
	services = mockProtocol(@protocol(MSFViewModelServices));
	MSFClient *client = mock([MSFClient class]);
	[given([services httpClient]) willReturn:client];
	
	MSFCoupon *model = mock([MSFCoupon class]);
	stubProperty(model, effectDateBegin, [NSDateFormatter msf_dateFromString:@"2015-05-03T15:38:45Z"]);
	stubProperty(model, effectDateEnd, [NSDateFormatter msf_dateFromString:@"2015-05-07T15:38:45Z"]);
	stubProperty(model, ticketName, @"bar");
	stubProperty(model, receiveChannel, @"ios");
	stubProperty(model, type, @"foo");
	
	[given([client fetchCouponsWithStatus:@""]) willReturn:[RACSignal return:model]];
	
	BOOL success;
	NSError *error;
	
  // when
	
	sut = [[MSFCouponsViewModel alloc] initWithServices:services];
	NSArray *results = [[sut.executeFetchCommand execute:@""] asynchronousFirstOrDefault:nil success:&success error:&error];
	
  // then
	expect(sut).notTo(beNil());
	expect(results).notTo(beNil());
	
	expect(@(success)).to(beTruthy());
	expect(error).to(beNil());
	
	expect(sut.viewModels).notTo(beNil());
	
	MSFCouponViewModel *viewModel = sut.viewModels.firstObject;
	expect(viewModel.title).to(equal(@"bar"));
});

QuickSpecEnd
