//
// MSFClient+LoanTypes.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+LoanTypes.h"
#import "MSFLoanType.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (LoanTypes)

- (RACSignal *)fetchLoanTypes {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"user/productList" parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFLoanType.class] msf_parsedResults];
}

@end
