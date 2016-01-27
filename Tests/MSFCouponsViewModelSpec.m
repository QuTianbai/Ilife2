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
__block MSFCoupon *model;
__block MSFClient *client;

beforeEach(^{
	model = mock([MSFCoupon class]);
	stubProperty(model, effectDateBegin, [NSDateFormatter msf_dateFromString:@"2015-05-03T15:38:45Z"]);
	stubProperty(model, effectDateEnd, [NSDateFormatter msf_dateFromString:@"2015-05-07T15:38:45Z"]);
	stubProperty(model, ticketName, @"bar");
	stubProperty(model, receiveChannel, @"ios");
	stubProperty(model, type, @"foo");
	
	services = mockProtocol(@protocol(MSFViewModelServices));
	client = mock([MSFClient class]);
	[given([services httpClient]) willReturn:client];
	
	sut = [[MSFCouponsViewModel alloc] initWithServices:services];
});

it(@"should initialize", ^{
  // given
	[given([client fetchCouponsWithStatus:@""]) willReturn:[RACSignal return:model]];
	
	BOOL success;
	NSError *error;
	
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


it(@"should get nil view models when an error occur", ^{
	// given
	[given([client fetchCouponsWithStatus:@""]) willReturn:[RACSignal return:model]];
	[[sut.executeFetchCommand execute:@""] asynchronousFirstOrDefault:nil success:nil error:nil];
	
	// when
	[given([client fetchCouponsWithStatus:@""]) willReturn:[RACSignal error:[NSError errorWithDomain:@"" code:10 userInfo:@{}]]];
	[[sut.executeFetchCommand execute:@""] asynchronousFirstOrDefault:nil success:nil error:nil];
	
	// then
	expect(@(sut.viewModels.count)).to(equal(@0));
});

QuickSpecEnd
