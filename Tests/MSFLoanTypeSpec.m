//
// MSFLoanTypeSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoanType.h"

QuickSpecBegin(MSFLoanTypeSpec)

__block MSFLoanType *sut;

beforeEach(^{
	sut = [MTLJSONAdapter modelOfClass:[MSFLoanType class] fromJSONDictionary:@{@"productId": @"4011"} error:nil];
	expect(sut).notTo(beNil());
});

it(@"should initialize", ^{
  // then
	expect(sut.objectID).to(equal(@"4011"));
});

QuickSpecEnd
