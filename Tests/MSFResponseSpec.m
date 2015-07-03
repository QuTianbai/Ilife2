//
// MSFResponseSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFResponse.h"

QuickSpecBegin(MSFResponseSpec)

__block MSFResponse *response;
__block NSDictionary *headers;

beforeEach(^{
  headers = @{};
  NSHTTPURLResponse *HTTPURLResponse = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://example.com"] statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headers];
  response = [[MSFResponse alloc] initWithHTTPURLResponse:HTTPURLResponse parsedResult:nil];
});

it(@"should initialize", ^{
  // then
  expect(response).notTo(beNil());
  expect(@(response.statusCode)).to(equal(@200));
});

QuickSpecEnd
