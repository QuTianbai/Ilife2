//
//  MSFClient+MSFApplyList.m
//  Cash
//
//  Created by xbm on 15/5/16.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+MSFApplyList.h"
#import "MSFApplyList.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (MSFApplyList)

- (RACSignal *)fetchApplyList {
  NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
  NSURLRequest *request = [self requestWithMethod:@"GET" path:@"loans" parameters:parameters];
  
  return [[self enqueueRequest:request resultClass:MSFApplyList.class] msf_parsedResults];
}

@end
