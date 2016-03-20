//
//  MSFClient+MSFProductType.m
//  Finance
//
//  Created by 赵勇 on 11/21/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient+ProductType.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFResponse.h"

@implementation MSFClient (ProductType)

- (RACSignal *)fetchProductType {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"user/productList" parameters:nil];
	return [[self enqueueRequest:request resultClass:nil].collect map:^id(NSArray *value) {
		NSMutableArray *array = [NSMutableArray array];
		[value enumerateObjectsUsingBlock:^(MSFResponse *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
			NSAssert([obj.parsedResult isKindOfClass:NSDictionary.class], @"ProductType : type error.");
			[array addObject:obj.parsedResult[@"productId"]];
		}];
		return array;
	}];
}

@end
