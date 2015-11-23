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
#import "MSFElement+Private.h"
#import "MSFResponse.h"

@implementation MSFClient (Elements)

- (RACSignal *)fetchElementsApplicationNo:(NSString *)applicaitonNo productID:(NSString *)productID {
	NSParameterAssert(applicaitonNo);
	NSParameterAssert(productID);
	
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"append/getSecurityFile" parameters:@{
		@"productId": productID,
	}];
	return [[self enqueueRequest:request resultClass:MSFElement.class] map:^id(MSFResponse *response) {
		MSFElement *element = response.parsedResult;
		element.applicationNo = applicaitonNo;
		return element;
	}];
}

- (RACSignal *)fetchSupplementalElementsApplicationNo:(NSString *)applicaitonNo productID:(NSString *)productID {
	NSParameterAssert(applicaitonNo);
	NSParameterAssert(productID);
	
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"append/getFile" parameters:@{
		@"applyNo": applicaitonNo,
		@"productId": productID,
	}];
	return [[self enqueueRequest:request resultClass:MSFElement.class] map:^id(MSFResponse *response) {
		MSFElement *element = response.parsedResult;
		element.applicationNo = applicaitonNo;
		return element;
	}];
}

- (RACSignal *)fetchElementsApplicationNo:(NSString *)applicaitonNo amount:(NSString *)amount terms:(NSString *)terms {
	NSParameterAssert(applicaitonNo);
	NSParameterAssert(amount);
	NSParameterAssert(terms);
	
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/getFile" parameters:@{
		@"productCode": self.user.type,
		@"amount": amount,
		@"loanTerm": terms,
	}];
	return [[self enqueueRequest:request resultClass:MSFElement.class] map:^id(MSFResponse *response) {
		MSFElement *element = response.parsedResult;
		element.applicationNo = applicaitonNo;
		return element;
	}];
}

@end
