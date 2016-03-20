//
// MSFObjectSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

QuickSpecBegin(MSFObjectSpec)

__block MSFObject *object;

beforeEach(^{
  object = [[MSFObject alloc] initWithDictionary:@{@"objectID": @"123"} error:nil];
});

it(@"should initialize", ^{
  // given
  
  // when
  
  // then
  expect(object).notTo(beNil());
  expect(object.objectID).to(equal(@"123"));
});

QuickSpecEnd
