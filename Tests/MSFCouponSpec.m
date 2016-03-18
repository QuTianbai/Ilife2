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
	@"id" : @"B788FAB9FE7617C5",
	@"ticketRuleId" : @69,
	@"ticketRuleName" : @"春节果冻",
	@"ticketType" : @"直抵券",
	@"phone" : @"18500609316",
	@"receiveTime" : @1453716514000,
	@"receiveChannel" : [NSNull null],
	@"effectDateBegin" : @"2016-01-25",
	@"effectDateEnd" : @"2016-01-30",
	@"status" : @"B",
	@"faceValue" : [NSNull null]
};

beforeEach(^{
	sut = [MTLJSONAdapter modelOfClass:[MSFCoupon class] fromJSONDictionary:representation error:nil];
});

it(@"should initialize", ^{
  // then
	expect(sut).notTo(beNil());
	expect(sut.objectID).to(equal(@"B788FAB9FE7617C5"));
	expect(@(sut.ticketRuleId)).to(equal(@(69)));
	expect(sut.ticketName).to(equal(@"春节果冻"));
	expect(sut.type).to(equal(@"直抵券"));
	expect(sut.phone).to(equal(@"18500609316"));
	expect(sut.receiveChannel).to(beNil());
	expect(sut.receiveTime).to(equal([NSDate dateWithTimeIntervalSince1970:1453716514]));
	expect(sut.effectDateBegin).to(equal([NSDateFormatter msf_dateFromString:@"2016-01-25"]));
	expect(sut.effectDateEnd).to(equal([NSDateFormatter msf_dateFromString:@"2016-01-30"]));
	expect(sut.status).to(equal(@"B"));
	expect(sut.value).to(beNil());
});

QuickSpecEnd
