//
//  MSFClient+MSFOrder.m
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFOrder.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFOrder.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFUser.h"

@implementation MSFClient(MSFOrder)

- (RACSignal *)fetchOrderList:(NSString *)status pageNo:(NSInteger)pn {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSArray *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MSFOrderJson" ofType:@"json"]] options:kNilOptions error:nil];
		NSArray *arr = [MTLJSONAdapter modelsOfClass:MSFOrder.class fromJSONArray:json error:nil];
		[subscriber sendNext:arr];
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

@end
