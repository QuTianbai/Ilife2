//
// MSFClient+Elements.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Elements.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFElement.h"
#import "MSFProduct.h"

@implementation MSFClient (Elements)

- (RACSignal *)fetchElementsWithProduct:(MSFProduct *)product {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"attachment/product" parameters:@{
		@"productId": product.productId ?: @"",
	}];
	return [[self enqueueRequest:request resultClass:MSFElement.class] msf_parsedResults];
}

@end
