//
// MSFTestDatabaseClient.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTestLogClient.h"
#import "MSFClient.h"

static MSFClient *client;

@implementation MSFTestLogClient

+ (void)setHTTPClient:(MSFClient *)_client {
  client = _client;
}

- (MSFClient *)client {
  return client;
}

@end
