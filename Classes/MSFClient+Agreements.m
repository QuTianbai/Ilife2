//
// MSFClient+Agreements.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Agreements.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFProduct.h"

@implementation MSFClient (Agreements)

- (RACSignal *)fetchAgreementURLWithProduct:(MSFProduct *)product {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self requestWithMethod:@"GET" path:@"coresys/cont/contract/fineinfo" parameters:@{
			@"productId": product.productId ?: @"",
		}];
		[subscriber sendNext:request];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end
