//
// MSFCouponViewModelSpec.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCouponViewModel.h"
#import "MSFCoupon.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFClient.h"
#import "MSFCipher.h"

QuickSpecBegin(MSFCouponViewModelSpec)

__block MSFCouponViewModel *sut;
__block MSFCoupon *model;

it(@"should initialize", ^{
  // given
	model = mock([MSFCoupon class]);
	stubProperty(model, effectDateBegin, [NSDateFormatter msf_dateFromString:@"2015-05-03T15:38:45Z"]);
	stubProperty(model, effectDateEnd, [NSDateFormatter msf_dateFromString:@"2015-05-07T15:38:45Z"]);
	stubProperty(model, ticketName, @"bar");
	stubProperty(model, receiveChannel, @"ios");
	stubProperty(model, type, @"foo");
	stubProperty(model, productName, @"foo");
	
  // when
	sut = [[MSFCouponViewModel alloc] initWithModel:model];
	
  // then
	expect(sut).notTo(beNil());
	expect(sut.title).to(equal(@"bar"));
	expect(sut.subtitle).to(equal(@"foo"));
	expect(sut.value).to(beNil());
	expect(sut.intro).to(equal(@"foo"));
	expect(sut.timeRange).to(equal(@"2015-05-03 至 2015-05-07"));
	expect(sut.timeLeft).to(equal(@"已过期"));
	expect(@(sut.days)).notTo(equal(0));
	expect(@(sut.isWarning)).to(beTruthy());
});

QuickSpecEnd
