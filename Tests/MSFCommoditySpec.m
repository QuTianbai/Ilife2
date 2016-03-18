//
// MSFCommoditySpec.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCommodity.h"

QuickSpecBegin(MSFCommoditySpec)

__block MSFCommodity *sut;

it(@"should initialize", ^{
	// given
	sut = [MTLJSONAdapter modelOfClass:[MSFCommodity class] fromJSONDictionary:@{} error:nil];
	
	// when
	
	// then
	expect(sut).notTo(beNil());
});

QuickSpecEnd
