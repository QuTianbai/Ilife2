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

- (RACSignal *)fetchDownPayment:(MSFOrderDetail *)order password:(NSString *)password authType:(NSString *)auth {
	NSDictionary *parameters = @{
		@"transPassword": password,
		@"authType": @"O",
		@"authId": order.inOrderId
	};
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"pay/paymentInfo" parameters:parameters];
	
	return [[self enqueueRequest:request resultClass:MSFPayment.class] msf_parsedResults];
}

- (RACSignal *)downPaymentWithPayment:(MSFOrderDetail *)order SMSCode:(NSString *)smsCode SMSSeqNo:(NSString *)seqNo {
	NSDictionary *parameters = @{
		@"inOrderId": order.inOrderId,
		@"smsCode": smsCode,
		@"smsSeqNo": seqNo,
		@"downPmt": order.downPmt,
	};
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"pay/downPayment" parameters:parameters];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)requestLoan:(MSFOrderDetail *)order {
	NSDictionary *parameters = @{
		@"inOrderId": order.inOrderId,
	};
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"pay/makeLoans" parameters:parameters];
	
	return [self enqueueRequest:request resultClass:nil];
}

@end