//
// MSFAuthorizationSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAuthorization.h"

QuickSpecBegin(MSFAuthorizationSpec)

__block MSFAuthorization *authorization;
__block NSDictionary *headers;

beforeEach(^{
  headers = @{
    @"token": @"b31a4a3576a44da3a340d565dc9824b8",
    };
  NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:[NSURL URLWithString:@"http://example.com"] statusCode:200 HTTPVersion:@"HTTP/1.0" headerFields:headers];
  
  authorization = [MTLJSONAdapter modelOfClass:MSFAuthorization.class fromJSONDictionary:response.allHeaderFields error:nil];
});

it(@"should initialize", ^{
  // then
  expect(authorization.token).to(equal(@"b31a4a3576a44da3a340d565dc9824b8"));
});

QuickSpecEnd
