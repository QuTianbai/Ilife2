//
// MSFClient+Payment.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Payment.h"
#import "MSFOrderDetail.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFPayment.h"

@implementation MSFClient (Payment)

- (RACSignal *)paymentWithOrder:(MSFOrderDetail *)order password:(NSString *)password {
	NSDictionary *parameters = @{
		@"transPassword": password,
		@"authType": @"O",
		@"authId": order.inOrderId
	};
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"pay/payCode" parameters:parameters];
	
	return [[self enqueueRequest:request resultClass:MSFPayment.class] msf_parsedResults];
}

@end
