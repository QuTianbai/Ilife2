//
// MSFTestDatabaseClient.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLogClient.h"

@class MSFClient;

@interface MSFTestLogClient : MSFLogClient

+ (void)setHTTPClient:(MSFClient *)client;

@end
