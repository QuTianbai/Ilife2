//
// MSFClient+Agreements.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Agreements.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFApplyCashVIewModel.h"
#import "MSFUtils.h"

@implementation MSFClient (Agreements)

- (RACSignal *)fetchAgreementURLWithProduct:(MSFApplyCashVIewModel *)product {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/treaty" parameters:@{@"productCode": MSFUtils.productCode ?: @"", @"appLmt" :product.appLmt?:@"", @"loanTerm" : product.loanTerm
		}];
		[subscriber sendNext:request];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end
