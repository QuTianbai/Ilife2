//
// MSFIntergrantSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFIntergrant.h"

QuickSpecBegin(MSFIntergrantSpec)

__block MSFIntergrant *sut;
NSURL *URL = [NSURL URLWithString:@"http://objczl.com"];

beforeEach(^{
	sut = [[MSFIntergrant alloc] initWithUpgrade:YES HTMLURL:URL];
});

it(@"should initialize", ^{
  // then
	expect(sut).notTo(beNil());
});

it(@"should be true for load webview", ^{
	// then
	expect(@(sut.isUpgrade)).to(beTruthy());
	expect(sut.HTMLURL).to(equal(URL));
});

QuickSpecEnd
