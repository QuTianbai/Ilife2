//
// MSFClient+Amortize.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Amortize.h"
#import "MSFAmortize.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (Amortize)

- (RACSignal *)fetchAmortizeWithProductCode:(NSString *)productCode {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/product" parameters:@{
		@"productCode": productCode,
	}];
	
	return [[self enqueueRequest:request resultClass:MSFAmortize.class] msf_parsedResults];
}

@end
