//
// MSFTravelSpec.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFTravel.h"

QuickSpecBegin(MSFTravelSpec)

__block MSFTravel *sut;
NSDictionary *representation = @{
	@"departureTime" : @"212132112893",
	@"returnTime" : @"1278321837821738",
	@"isNeedVisa" : @"YES",
	@"origin" : @"Chongqing",
	@"destination" : @"Beijing",
	@"travelNum" : @0,
	@"travelKidsNum" : @0,
	@"travelType" : @"foo"
};

beforeEach(^{
	sut = [MTLJSONAdapter modelOfClass:[MSFTravel class] fromJSONDictionary:representation error:nil];
});

it(@"should initialize", ^{
  // then
	expect(sut).notTo(beNil());
	expect(sut.departureTime).to(equal(@"1976-09-21"));
	expect(sut.returnTime).to(equal(@"42478-05-28"));
	expect(sut.isNeedVisa).to(equal(@"YES"));
	expect(sut.origin).to(equal(@"Chongqing"));
	expect(sut.destination).to(equal(@"Beijing"));
	expect(@(sut.travelNum)).to(equal(@0));
	expect(@(sut.travelKidsNum)).to(equal(@0));
	expect(sut.travelType).to(equal(@"foo"));
});

QuickSpecEnd
