//
// MSFElementSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFElement.h"
#import "MSFObject+Private.h"
#import "MSFServer.h"

QuickSpecBegin(MSFElementSpec)

NSDictionary *representation = @{
	@"code": @"IDCARD",
	@"name": @"身份证",
	@"maxNum": @1,
	@"iconUrl": @"111.icon",
	@"exampleUrl": @"111.jsp",
	@"title": @"身份证",
	@"sort": @4,
	@"comment": @"请放在正中间",
	@"status": @"M",
};

__block MSFElement *element;

beforeEach(^{
	element = [MTLJSONAdapter modelOfClass:MSFElement.class fromJSONDictionary:representation error:nil];
	expect(element).notTo(beNil());
	
	element.baseURL = [NSURL URLWithString:@"http://example.com"];
	expect(element.server).notTo(beNil());
	expect(element.server.baseURL).to(equal([NSURL URLWithString:@"http://example.com"]));
});

it(@"should initialize", ^{
  // then
	expect(element.type).to(equal(@"IDCARD"));
	expect(element.title).to(equal(@"身份证"));
	expect(element.comment).to(equal(@"请放在正中间"));
	expect(element.relativeSamplePath).to(equal(@"111.jsp"));
	expect(element.relativeThumbPath).to(equal(@"111.icon"));
	expect(@(element.required)).to(beTruthy());
	expect(@(element.maximum)).to(equal(@1));
	expect(@(element.sort)).to(equal(@4));
});

it(@"should has exampleURL", ^{
	// then
	expect(element.sampleURL).to(equal([NSURL URLWithString:@"http://example.com/111.jsp"]));
});

it(@"should has thumbURL", ^{
	// then
	expect(element.thumbURL).to(equal([NSURL URLWithString:@"http://example.com/111.icon"]));
});

it(@"should be not required element", ^{
	// given
	NSDictionary *representation = @{
		@"status": @"O",
	};
	
	// when
	element = [MTLJSONAdapter modelOfClass:MSFElement.class fromJSONDictionary:representation error:nil];
	
	// then
	expect(@(element.required)).to(beFalsy());
});

QuickSpecEnd
