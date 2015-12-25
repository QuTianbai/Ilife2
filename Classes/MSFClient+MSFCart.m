//
//  MSFClient+MSFCart.m
//  Finance
//
//  Created by 赵勇 on 12/25/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFCart.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACSignal+MSFClientAdditions.h"
#import "MSFCart.h"

@implementation MSFClient(MSFCart)

- (RACSignal *)fetchCart:(NSString *)cartId {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:[NSString stringWithFormat:@"orders/product/%@", cartId] parameters:nil];
	return [self enqueueRequest:request resultClass:MSFCart.class].msf_parsedResults;
}

@end
