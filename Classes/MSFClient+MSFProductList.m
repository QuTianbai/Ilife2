//
//  MSFClient+MSFProductList.m
//  Finance
//
//  Created by xbm on 15/11/23.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFProductList.h"
#import "MSFProductListModel.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (MSFProductList)

- (RACSignal *)fetchProductList {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"user/productList" parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFProductListModel.class] msf_parsedResults];
}

@end
