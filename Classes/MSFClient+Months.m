//
// MSFClient+Months.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Months.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFResponse.h"
#import "MSFProduct.h"

@implementation MSFClient (Months)

- (RACSignal *)fetchTermPayWithProduct:(MSFProduct *)product totalAmount:(NSInteger)amount insurance:(BOOL)insurance {
	//TODO: 返回固定贷款值
//	MSFResponse *response = [[MSFResponse alloc] initWithHTTPURLResponse:nil parsedResult:@{@"repayMoneyMonth": @"300"}];
//	return [RACSignal return:response];
	
	NSMutableDictionary *parameters = NSMutableDictionary.new;
	parameters[@"principal"] = @(amount);
	parameters[@"productId"] = product.productId;
	parameters[@"isSafePlan"] = @(insurance);
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"loans/product" parameters:parameters];
	
	return [self enqueueRequest:request resultClass:nil];
}

@end
