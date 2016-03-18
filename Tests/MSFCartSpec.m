//
// MSFCartSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFCart.h"
#import "MSFTravel.h"

QuickSpecBegin(MSFCartSpec)

__block MSFCart *sut;

describe(@"commodities", ^{
	beforeEach(^{
		sut = [MTLJSONAdapter modelOfClass:[MSFCart class] fromJSONDictionary:@{
			@"isDownPmt": @"1",
			@"orderTravelDto": @{},
			@"cartType": @"goods",
			@"travelCompanInfoList": @[],
		} error:nil];
	});

	it(@"should initialize", ^{
		// then
		expect(sut).notTo(beNil());
	});
});

describe(@"travel", ^{
	beforeEach(^{
		sut = [MTLJSONAdapter modelOfClass:[MSFCart class] fromJSONDictionary:@{
			@"isDownPmt": @"1",
			@"orderTravelDto": @{
				@"origin": @"foo",
				@"destination": @"bar"
			},
			@"travelCompanInfoList": @[],
		} error:nil];
	});
	
	it(@"should has Down payment flag", ^{
		// then
		expect(@(sut.isDownPmt)).to(beTruthy());
	});

	it(@"should separate commodity and travel", ^{
		// then
		expect(sut.travel).to(beAKindOf([MSFTravel class]));
		expect(sut.travel.origin).to(equal(@"foo"));
		expect(sut.travel.destination).to(equal(@"bar"));
	});
	
	it(@"should have companions", ^{
		// then
		expect(sut.companions).to(beAKindOf([NSArray class]));
	});
});


QuickSpecEnd
