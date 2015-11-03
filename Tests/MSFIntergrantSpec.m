//
// MSFIntergrantSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFIntergrant.h"
#import <Mantle/EXTKeyPathCoding.h>

QuickSpecBegin(MSFIntergrantSpec)

__block MSFIntergrant *sut;

beforeEach(^{
	sut = [[MSFIntergrant alloc] initWithDictionary:@{
		@keypath(MSFIntergrant.new, isUpgrade) : @YES,
		@keypath(MSFIntergrant.new, bref): @"path",
	} error:nil];
});

it(@"should initialize", ^{
  // then
	expect(sut).notTo(beNil());
});

it(@"should be true for load webview", ^{
	// then
	expect(@(sut.isUpgrade)).to(beTruthy());
	expect(sut.bref).to(equal(@"path"));
});

QuickSpecEnd
