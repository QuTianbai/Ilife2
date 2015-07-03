//
// MSFAgreement.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAgreement.h"
#import "MSFServer.h"
#import <libextobjc/extobjc.h>

@implementation MSFAgreement

- (instancetype)initWithServer:(MSFServer *)server {
  return [super initWithDictionary:@{@keypath(self.server): server} error:nil];
}

- (NSURL *)userURL {
  return [self.server.baseWebURL URLByAppendingPathComponent:@"agreement/user"];
}

- (NSURL *)loanURL {
  return [self.server.baseWebURL URLByAppendingPathComponent:@"agreement/loan"];
}

- (NSURL *)aboutWeURL {
  return [self.server.baseWebURL URLByAppendingPathComponent:@"app/about.htm"];
}

- (NSURL *)productURL {
  return [self.server.baseWebURL URLByAppendingPathComponent:@"app/intro.htm "];
}

- (NSURL *)helpURL {
  return [self.server.baseWebURL URLByAppendingPathComponent:@"app/help.htm"];
}

- (NSURL *)branchesURL {
  
  return [self.server.baseWebURL URLByAppendingPathComponent:@"app/branch.htm"];
}

- (NSURL *)repayURL {
  return [self.server.APIEndpoint URLByAppendingPathComponent:@"/coresys/cont/contract/pageQuery?applyId="];
}

- (NSURL *)registerURL {
  return [self.server.baseWebURL URLByAppendingPathComponent:@"agreement.htm"];
}

@end
