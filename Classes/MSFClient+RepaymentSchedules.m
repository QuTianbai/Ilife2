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
	NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"repayment" ofType:@"json"];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:jsonPath]];
	
	//NSString *path = @"finance/schedules";
	//NSURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFRepaymentSchedules.class] msf_parsedResults];
}

- (RACSignal *)fetchCircleRepaymentSchedules {
	NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"circleCash" ofType:@"json"];
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:jsonPath]];
	
	//NSString *path = @"append/schedules";
	//NSURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFRepaymentSchedules.class] msf_parsedResults];
}

@end
