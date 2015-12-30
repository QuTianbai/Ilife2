//
// MSFOrderDetailSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFOrderDetail.h"

QuickSpecBegin(MSFOrderDetailSpec)

__block MSFOrderDetail *sut;

beforeEach(^{
	NSString *file = [[NSBundle bundleForClass:self.class] pathForResource:@"order-details" ofType:@"json"];
	NSData *data = [NSData dataWithContentsOfFile:file];
	NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
	sut = [MTLJSONAdapter modelOfClass:[MSFOrderDetail class] fromJSONDictionary:representation error:nil];
});

it(@"should initialize", ^{
	expect(sut).notTo(beNil());
});

QuickSpecEnd
