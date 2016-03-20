//
// MSFClient+Wallet.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Wallet.h"
#import "MSFWallet.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (Wallet)

- (RACSignal *)fetcchWallet {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"query/checkBalance" parameters:@{@"type": @"4"}];
	return [[self enqueueRequest:request resultClass:MSFWallet.class] msf_parsedResults];
}

@end
