//
//  MSFClient+MSFOrder.m
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient+Order.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACSignal+MSFClientAdditions.h"
#import "MSFOrderDetail.h"
#import "MSFOrder.h"
#import "MSFUser.h"

@implementation MSFClient(Order)

- (RACSignal *)fetchOrderList:(NSString *)status pageNo:(NSInteger)pn {
	NSDictionary *params = @{@"uniqueId" : self.user.objectID,
													 @"orderStatus" : status ?: @"",
													 @"pageSize" : @10,
													 @"pageNo" : @(pn)};
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"orders/list" parameters:params];
	return [[self enqueueRequest:request resultClass:MSFOrder.class] msf_parsedResults];
}

- (RACSignal *)fetchOrder:(NSString *)orderId {
	 NSURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"orders/%@", orderId] parameters:nil];
	 return [[self enqueueRequest:request resultClass:MSFOrderDetail.class] msf_parsedResults];
}

- (RACSignal *)fetchMyOrderListWithType:(NSString *)type {
	//	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"query/repaymentList" parameters:@{
	//									@"type": type,
	//								}];
	NSString *path = [[NSBundle mainBundle] pathForResource:@"myOderList" ofType:@"json"];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:path]];
	return [[self enqueueRequest:request resultClass:MSFOrder.class] msf_parsedResults];
}

@end
