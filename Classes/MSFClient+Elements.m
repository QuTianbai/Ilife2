//
// MSFClient+Elements.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Elements.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFElement.h"
#import "MSFUser.h"
#import "MSFElement+Private.h"
#import "MSFResponse.h"

@implementation MSFClient (Elements)

- (RACSignal *)fetchElementsApplicationNo:(NSString *)applicaitonNo productID:(NSString *)productID {
	NSParameterAssert(applicaitonNo);
	NSParameterAssert(productID);
	
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"append/getSecurityFile" parameters:@{
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
	
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"append/getFile" parameters:@{
		@"applyNo": applicaitonNo,
		@"productId": productID,
	}];
	return [[self enqueueRequest:request resultClass:MSFElement.class] map:^id(MSFResponse *response) {
		MSFElement *element = response.parsedResult;
		element.applicationNo = applicaitonNo;
		return element;
	}];
}

- (RACSignal *)fetchElementsApplicationNo:(NSString *)applicaitonNo amount:(NSString *)amount terms:(NSString *)terms productGroupID:(NSString *)groupID {
	NSParameterAssert(applicaitonNo);
	NSParameterAssert(amount);
	NSParameterAssert(terms);
	
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/getFile" parameters:@{
		@"productCode": groupID,
		@"amount": amount,
		@"loanTerm": terms,
	}];
	return [[self enqueueRequest:request resultClass:MSFElement.class] map:^id(MSFResponse *response) {
		MSFElement *element = response.parsedResult;
		element.applicationNo = applicaitonNo;
		return element;
	}];
}

- (RACSignal *)fetchFaceMaskElements {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"picture/getFaceDocument" parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFElement.class] msf_parsedResults];
}

@end
