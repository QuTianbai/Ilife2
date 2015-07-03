//
//  MSFClient+MSFAdver.m
//  Cash
//
//  Created by xbm on 15/5/14.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+MSFAdver.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFAdver.h"

@implementation MSFClient (MSFAdver)

- (RACSignal *)fetchAdver {
  NSURLRequest *request = [self requestWithMethod:@"GET" path:@"ads/1" parameters:nil];
  
  return [[self enqueueRequest:request resultClass:MSFAdver.class] msf_parsedResults];
}

- (RACSignal *)fetchAdverWithCategory:(NSString *)category {
  NSString *path = [NSString stringWithFormat:@"ads/%@",category];
  NSURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:nil];
  
  return [[self enqueueRequest:request resultClass:MSFAdver.class] msf_parsedResults];
}

@end
