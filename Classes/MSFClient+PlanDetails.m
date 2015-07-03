//
//  MSFClient+PlanDetails.m
//  Cash
//
//  Created by xutian on 15/5/15.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+PlanDetails.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFPlanDetails.h"

@implementation MSFClient (PlanDetails)

- (RACSignal *)fetchPlanDetails:(MSFRepaymentSchedules *)repaymentSchedulesID {
  NSString *planID = [NSString stringWithFormat:@"plans/%@",repaymentSchedulesID.repaymentTime];
  NSURLRequest *requset = [self requestWithMethod:@"GET" path:planID parameters:nil];
  
  return [[self enqueueRequest:requset resultClass:MSFPlanDetails.class] msf_parsedResults];
}

@end
