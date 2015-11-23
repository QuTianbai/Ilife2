//
//  MSFClient+MSFProductType.m
//  Finance
//
//  Created by 赵勇 on 11/21/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFProductType.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (MSFProductType)

- (RACSignal *)fetchProductType {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"user/productList" parameters:nil];
	return [[self enqueueRequest:request resultClass:nil] map:^id(NSArray *value) {
		NSMutableArray *array = [NSMutableArray array];
		[value enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			NSAssert([obj isKindOfClass:NSDictionary.class], @"ProductType : type error.");
			[array addObject:obj[@"productId"]];
		}];
		return array;
	}];
}

@end
