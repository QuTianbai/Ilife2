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

- (RACSignal *)fetchElementsWithProduct:(MSFProduct *)product amount:(NSString *)amount term:(NSString *)term {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/getFile" parameters:@{
		@"productCode": self.user.type,
		@"amount": amount ?: @"",
		@"loanTerm": term ?: @"",
	}];
	return [[self enqueueRequest:request resultClass:MSFElement.class] msf_parsedResults];
}

- (RACSignal *)fetchElementsApplicationNo:(NSString *)applicaitonNo productID:(NSString *)productID {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"append/getFile" parameters:@{
		@"productId": productID,
		@"applyNo": applicaitonNo,
	}];
	return [[self enqueueRequest:request resultClass:MSFElement.class] map:^id(MSFResponse *response) {
		MSFElement *element = response.parsedResult;
		element.applicationNo = applicaitonNo;
		return element;
	}];
}

- (RACSignal *)fetchElementsApplicationNo:(NSString *)applicaitonNo amount:(NSString *)amount terms:(NSString *)terms {
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
