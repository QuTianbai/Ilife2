//
//  MSFClient+PlanPerodicTable.m
//  Cash
//
//  Created by xutian on 15/5/15.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+PlanPerodicTables.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFPlanPerodicTables.h"

@implementation MSFClient (PlanPerodicTables)

- (RACSignal *)fetchPlanPerodicTables:(MSFRepaymentSchedules *)repaymentSchedules {
  NSString *pPerodTableID = [NSString stringWithFormat:@"plans/%@/installments",repaymentSchedules.contractNum];
  NSURLRequest *requset = [self requestWithMethod:@"GET" path:pPerodTableID parameters:nil];
  
  return [[self enqueueRequest:requset resultClass:MSFPlanPerodicTables.class] msf_parsedResults];
}

@end
