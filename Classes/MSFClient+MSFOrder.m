//
//  MSFClient+MSFOrder.m
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFOrder.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACSignal+MSFClientAdditions.h"
#import "MSFOrderEditViewModel.h"
#import "MSFOrderDetail.h"
#import "MSFOrder.h"
#import "MSFUser.h"

@implementation MSFClient(MSFOrder)

- (RACSignal *)fetchOrderList:(NSString *)status pageNo:(NSInteger)pn {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MSFOrderJson" ofType:@"json"]] options:kNilOptions error:nil];
		MSFOrder *order = [MTLJSONAdapter modelOfClass:MSFOrder.class fromJSONDictionary:json error:nil];
		[subscriber sendNext:order];
		[subscriber sendCompleted];
		return nil;
	}];
	/*
	NSDictionary *params = @{@"uniqueId" : self.user.uniqueId,
													 @"orderStatus" : status ?: @"",
													 @"pageSize" : @10,
													 @"pageNo" : @(pn)};
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"orders/list" parameters:params];
	return [[self enqueueRequest:request resultClass:MSFOrder.class] msf_parsedResults];
	*/
}

- (RACSignal *)fetchOrder:(NSString *)orderId {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MSFOrderDetailJson" ofType:@"json"]] options:kNilOptions error:nil];
		MSFOrderDetail *order = [MTLJSONAdapter modelOfClass:MSFOrderDetail.class fromJSONDictionary:json error:nil];
		[subscriber sendNext:order];
		[subscriber sendCompleted];
		return nil;
	}];
	/*
	 NSDictionary *params = @{@"order_id" : orderId};
	 NSURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"orders/%@", orderId] parameters:params];
	 return [[self enqueueRequest:request resultClass:MSFOrderDetail.class] msf_parsedResults];
	 */
}

- (RACSignal *)fetchTrialAmount:(MSFOrderDetail *)order {
	return [RACSignal return:@{@"loanFixedAmt" : @"1900.00",
														 @"lifeInsuranceAmt" : @"0.00"}];
	
	NSDictionary *params = [MTLJSONAdapter JSONDictionaryFromModel:order];
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"product/trial" parameters:params];
	return [self enqueueRequest:request resultClass:nil];
}

@end
