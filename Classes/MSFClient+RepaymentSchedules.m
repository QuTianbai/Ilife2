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
#import "MSFMyRepayDetailModel.h"

@implementation MSFClient (RepaymentSchedules)

- (RACSignal *)fetchRepaymentSchedules {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"finance/schedules" parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFRepaymentSchedules.class] msf_parsedResults];
}

- (RACSignal *)fetchCircleRepaymentSchedules {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"append/schedules" parameters:@{@"type": @"2"}];
	return [[self enqueueRequest:request resultClass:MSFRepaymentSchedules.class] msf_parsedResults];
}

- (RACSignal *)fetchMyRepayWithType:(NSString *)type {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"query/repaymentList" parameters:@{
									@"type": type,
								}];
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"myRepayList" ofType:@"json"];
//	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:path]];
	return [[self enqueueRequest:request resultClass:MSFRepaymentSchedules.class] msf_parsedResults];
}

- (RACSignal *)fetchMyDetailWithContractNo:(NSString *)contractNo type:(NSString *)type {
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"myRepayDetail" ofType:@"json"];
//	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:path]];

	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"query/detailInfo" parameters:@{@"type":type, @"contractNo":contractNo}];
	return [[self enqueueRequest:request resultClass:MSFMyRepayDetailModel.class]msf_parsedResults];
}

@end
