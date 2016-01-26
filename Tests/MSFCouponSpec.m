//
// MSFCouponSpec.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCoupon.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

QuickSpecBegin(MSFCouponSpec)

__block MSFCoupon *sut;

NSDictionary *representation = @{
	@"id" : @"foo",
	@"ticketRuleId" : @1,
	@"ticketName" : @"bar",
	@"type" : @"A",
	@"phone" : @"1869699565",
	@"receiveTime" : @"2015-05-03T15:38:45Z",
	@"receiveChannel" : @"ios",
	@"effectDateBegin" : @"2015-05-03T15:38:45Z",
	@"effectDateEnd" : @"2015-08-03T15:38:45Z",
	@"status" : @"1"
};

beforeEach(^{
	sut = [MTLJSONAdapter modelOfClass:[MSFCoupon class] fromJSONDictionary:representation error:nil];
});

it(@"should initialize", ^{
  // then
	expect(sut).notTo(beNil());
	expect(sut.objectID).to(equal(@"foo"));
	expect(@(sut.ticketRuleId)).to(equal(@(1)));
	expect(sut.ticketName).to(equal(@"bar"));
	expect(sut.type).to(equal(@"A"));
	expect(sut.phone).to(equal(@"1869699565"));
	expect(sut.receiveChannel).to(equal(@"ios"));
	expect(sut.receiveTime).to(equal([NSDateFormatter msf_dateFromString:@"2015-05-03T15:38:45Z"]));
	expect(sut.effectDateBegin).to(equal([NSDateFormatter msf_dateFromString:@"2015-05-03T15:38:45Z"]));
	expect(sut.effectDateEnd).to(equal([NSDateFormatter msf_dateFromString:@"2015-08-03T15:38:45Z"]));
	expect(sut.status).to(equal(@"1"));
});

QuickSpecEnd
