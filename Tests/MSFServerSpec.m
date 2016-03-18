//
// MSFServerSpec.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFServer.h"

QuickSpecBegin(MSFServerSpec)

__block MSFServer *server;

beforeEach(^{
  server = nil;
});

it(@"should initialize dotComServer", ^{
  // given
  server = MSFServer.dotComServer;
  
  // then
  expect(server.APIEndpoint).to(equal([NSURL URLWithString:@"https://api.msfinance.cn"]));
});

QuickSpecEnd
