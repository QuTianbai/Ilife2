//
// MSFClientAdditions.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RACSignal+MSFClientAdditions.h"
#import "MSFResponse.h"

@implementation RACSignal (MSFClientAdditions)

- (RACSignal *)msf_parsedResults {
	return [self map:^(MSFResponse *response) {
		NSAssert([response isKindOfClass:MSFResponse.class], @"Expected %@ to be an OCTResponse.", response);
		
		return response.parsedResult;
	}];
}

@end
