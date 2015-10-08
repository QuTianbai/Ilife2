//
// MSFElementSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFElement.h"

QuickSpecBegin(MSFElementSpec)

NSDictionary *representation = @{
	@"code": @"IDCARD",
	@"name": @"身份证",
	@"title": @"身份证",
	@"comment": @"请放在正中间",
	@"status": @"M",
	@"exampleUrl": @"http://www.aaa.com/111.jsp",
	@"iconUrl": @"http://www.aaa.com/111.icon",
	@"maxNum": @1
};

__block MSFElement *element;

beforeEach(^{
	element = [MTLJSONAdapter modelOfClass:MSFElement.class fromJSONDictionary:representation error:nil];
	expect(element).notTo(beNil());
});

it(@"should initialize", ^{
  // then
	expect(element.type).to(equal(@"IDCARD"));
	expect(element.title).to(equal(@"身份证"));
	expect(element.comment).to(equal(@"请放在正中间"));
	expect(element.sampleURL).to(equal([NSURL URLWithString:@"http://www.aaa.com/111.jsp"]));
	expect(element.thumbURL).to(equal([NSURL URLWithString:@"http://www.aaa.com/111.icon"]));
	expect(@(element.required)).to(beTruthy());
	expect(@(element.maximum)).to(equal(@1));
});

QuickSpecEnd
