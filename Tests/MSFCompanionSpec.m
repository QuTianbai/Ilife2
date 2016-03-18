//
// MSFCompanionSpec.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCompanion.h"

QuickSpecBegin(MSFCompanionSpec)

__block MSFCompanion *sut;

NSDictionary *representation = @{
	@"companName" : @"foo",
	@"companCellphone" : @"13539748374",
	@"companCertId" : @"43685384783437847",
	@"companRelationship" : @"bar"
};

beforeEach(^{
	sut = [MTLJSONAdapter modelOfClass:[MSFCompanion class] fromJSONDictionary:representation error:nil];
});

it(@"should initialize", ^{
  // then
	expect(sut).notTo(beNil());
	expect(sut.companName).to(equal(@"foo"));
	expect(sut.companCellphone).to(equal(@"13539748374"));
	expect(sut.companCertId).to(equal(@"43685384783437847"));
	expect(sut.companRelationship).to(equal(@"bar"));
});

QuickSpecEnd
