//
// MSFLoanTypeSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoanType.h"

QuickSpecBegin(MSFLoanTypeSpec)

__block MSFLoanType *sut;

beforeEach(^{
	sut = [[MSFLoanType alloc] initWithTypeID:@"4011"];
	expect(sut).notTo(beNil());
});

it(@"should initialize", ^{
  // then
	expect(sut.objectID).to(equal(@"4011"));
	expect(sut.typeID).to(equal(@"4011"));
});

QuickSpecEnd
