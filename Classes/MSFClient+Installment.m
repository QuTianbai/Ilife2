//
//  MSFClient+Staging.m
//  Cash
//
//  Created by xutian on 15/5/14.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Installment.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFInstallment.h"

@implementation MSFClient (Installment)

- (RACSignal *)fetchInstallment:(MSFPlanPerodicTables *)planPerodicTables {
  NSString *contractNum = [NSString stringWithFormat:@"installments/%@",planPerodicTables.contractNum];
  NSURLRequest *requset = [self requestWithMethod:@"GET" path:contractNum parameters:nil];
  
  return [[self enqueueRequest:requset resultClass:MSFInstallment.class] msf_parsedResults];
}

@end
