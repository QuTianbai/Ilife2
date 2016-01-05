//
// MSFCartSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFCart.h"

QuickSpecBegin(MSFCartSpec)

__block MSFCart *sut;

beforeEach(^{
	NSString *file = [[NSBundle bundleForClass:self.class] pathForResource:@"order-details" ofType:@"json"];
	NSData *data = [NSData dataWithContentsOfFile:file];
	NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
	sut = [MTLJSONAdapter modelOfClass:[MSFCart class] fromJSONDictionary:representation error:nil];
});

it(@"should initialize", ^{
	// then
	expect(sut).notTo(beNil());
});

QuickSpecEnd
