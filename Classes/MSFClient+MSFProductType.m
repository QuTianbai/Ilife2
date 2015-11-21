//
//  MSFClient+MSFProductType.m
//  Finance
//
//  Created by 赵勇 on 11/21/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFProductType.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFProductType.h"

@implementation MSFClient (MSFProductType)

- (RACSignal *)fetchProductType {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"user/productList" parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFProductType.class] msf_parsedResults];
}

@end
