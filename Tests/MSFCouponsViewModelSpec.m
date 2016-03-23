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
__block BOOL success;
__block NSError *error;

beforeEach(^{
	model = mock([MSFCoupon class]);
	stubProperty(model, effectDateBegin, [NSDateFormatter msf_dateFromString:@"2015-05-03T15:38:45Z"]);
	stubProperty(model, effectDateEnd, [NSDateFormatter msf_dateFromString:@"2015-05-07T15:38:45Z"]);
	stubProperty(model, ticketName, @"bar");
	stubProperty(model, receiveChannel, @"ios");
	stubProperty(model, type, @"foo");
	stubProperty(model, status, @"");
	
	services = mockProtocol(@protocol(MSFViewModelServices));
	client = mock([MSFClient class]);
	[given([services httpClient]) willReturn:client];
	
	sut = [[MSFCouponsViewModel alloc] initWithServices:services];
	expect(@(sut.active)).to(beFalsy());
	
	success = NO;
	error = nil;
});

it(@"should initialize", ^{
  // given
	[given([client fetchCouponsWithStatus:@"B"]) willReturn:[RACSignal return:model]];
	[given([client fetchCouponsWithStatus:@"C"]) willReturn:[RACSignal return:model]];
	[given([client fetchCouponsWithStatus:@"D"]) willReturn:[RACSignal return:model]];
	
	// when
	sut.active = YES;
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


fit(@"should get nil view models when an error occur", ^{
	// given
	[given([client fetchCouponsWithStatus:@"B"]) willReturn:[RACSignal error:[NSError errorWithDomain:@"" code:10 userInfo:@{}]]];
	[given([client fetchCouponsWithStatus:@"C"]) willReturn:[RACSignal return:model]];
	[given([client fetchCouponsWithStatus:@"D"]) willReturn:[RACSignal return:model]];
	
	// when
	sut.active = YES;
	[[sut.executeFetchCommand execute:@""] asynchronousFirstOrDefault:nil success:&success error:&error];
	
	// then
	expect(error).to(beNil());
	expect(@(success)).to(beTruthy());
	expect(@(sut.viewModels.count)).to(equal(@2));
});

QuickSpecEnd
