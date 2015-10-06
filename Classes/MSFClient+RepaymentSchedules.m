//
//	MSFClient+RepaymentSchedule.m
//	Cash
//
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+RepaymentSchedules.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFRepaymentSchedules.h"

@implementation MSFClient (RepaymentSchedules)

- (RACSignal *)fetchRepaymentSchedules {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"finance/schedules" parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFRepaymentSchedules.class] msf_parsedResults];
}

@end
