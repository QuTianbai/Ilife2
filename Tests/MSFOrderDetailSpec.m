//
// MSFOrderDetailSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFOrderDetail.h"
#import "MSFTravel.h"

QuickSpecBegin(MSFOrderDetailSpec)

__block MSFOrderDetail *sut;

describe(@"travel order", ^{
	it(@"should be a travel order", ^{
		// given
		NSDictionary *representation = @{
			@"isDownPmt": @1,
			@"orderTravelDto": @{
				@"origin": @"foo",
				@"destination": @"bar"
			},
			@"travelCompanInfoList": @[]
		};
		
		// when
		sut = [MTLJSONAdapter modelOfClass:[MSFOrderDetail class] fromJSONDictionary:representation error:nil];
		
		// then
		expect(sut.travel).to(beAKindOf([MSFTravel class]));
		expect(@(sut.isCommodity)).to(beFalsy());
		expect(sut.companions).notTo(beNil());
		expect(@(sut.isDownPmt)).to(beTruthy());
	});
});

QuickSpecEnd
