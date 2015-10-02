//
// MSFCardSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFCard.h"

QuickSpecBegin(MSFCardSpec)

__block MSFCard *card;

NSDictionary *representation = @{
	@"bankCardId" : @"1dafds782nj2",
	@"bankCardNo" : @"88******************888",
	@"bankCardType" : @"",
	@"bank_code" : @"",
	@"bankBranchCityCode" : @"",
	@"bankBranchProvinceCode" : @"",
	@"master" : @"yes"
};

beforeEach(^{
	card = [MTLJSONAdapter modelOfClass:[MSFCard class] fromJSONDictionary:representation error:nil];
});

it(@"should initialize", ^{
  // then
	expect(card).notTo(beNil());
	expect(card.cardID).to(equal(@"1dafds782nj2"));
	expect(card.number).to(equal(@"88******************888"));
	expect(card.type).to(equal(@""));
	expect(card.code).to(equal(@""));
	expect(card.city).to(equal(@""));
	expect(card.province).to(equal(@""));
	expect(card.master).to(equal(@"yes"));
});

QuickSpecEnd
