//
// MSFClient+Months.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Months.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFResponse.h"
#import "MSFProduct.h"
#import "SVProgressHUD.h"

@implementation MSFClient (Months)

- (RACSignal *)fetchTermPayWithProduct:(MSFProduct *)product totalAmount:(NSInteger)amount insurance:(BOOL)insurance {
	NSMutableDictionary *parameters = NSMutableDictionary.new;
	parameters[@"principal"] = @(amount);
	parameters[@"productId"] = product.productId;
	parameters[@"isSafePlan"] = @(insurance);
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"loans/product" parameters:parameters];
	[SVProgressHUD showWithStatus:@"正在计算每月所需还款金额..."];
	return [self enqueueRequest:request resultClass:nil];
}

@end
