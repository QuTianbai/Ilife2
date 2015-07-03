//
// MSFTestApplyViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTestApplyViewModel.h"

static MSFClient *client;

@implementation MSFTestApplyViewModel

+ (void)setHttpClient:(MSFClient *)httpClient {
  client = httpClient;
}

- (MSFClient *)client {
  return client;
}

@end
