//
// MSFClient+Elements.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Elements.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFElement.h"
#import "MSFProduct.h"
#import "MSFUser.h"

@implementation MSFClient (Elements)

- (RACSignal *)fetchElementsWithProduct:(MSFProduct *)product {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"attachment/product" parameters:@{
		@"productCode": self.user.type,
		@"amount": @"",
		@"loanTerm": @"",
	}];
	return [[self enqueueRequest:request resultClass:MSFElement.class] msf_parsedResults];
}

- (RACSignal *)fetchElementsWithProduct:(MSFProduct *)product amount:(NSString *)amount term:(NSString *)term {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/getFile" parameters:@{
		@"productCode": self.user.type,
		@"amount": amount ?: @"",
		@"loanTerm": term ?: @"",
	}];
	return [[self enqueueRequest:request resultClass:MSFElement.class] msf_parsedResults];
}

@end
