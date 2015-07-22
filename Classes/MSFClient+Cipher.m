//
// MSFClient+Cipher.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Cipher.h"

@implementation MSFClient (Cipher)

- (RACSignal *)fetchServerInterval {
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"app/server_time" parameters:nil];
	request.timeoutInterval = 3;
	
	return [self enqueueRequest:request resultClass:nil];
}

@end
