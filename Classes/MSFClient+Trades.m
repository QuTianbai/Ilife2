//
//  MSFClient+Trade.m
//  Cash
//
//  Created by xutian on 15/5/14.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Trades.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFTrade.h"

@implementation MSFClient (Trades)

- (RACSignal *)fetchTrades {
  NSURLRequest *requset = [self requestWithMethod:@"GET" path:@"transactions" parameters:nil];
  
  return [[self enqueueRequest:requset resultClass:MSFTrade.class] msf_parsedResults];
}

@end
