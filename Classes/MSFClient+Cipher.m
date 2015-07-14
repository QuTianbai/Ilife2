//
// MSFClient+Cipher.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Cipher.h"

@implementation MSFClient (Cipher)

- (RACSignal *)fetchServerInterval {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"app/server_time" parameters:nil];
	
	return [self enqueueRequest:request resultClass:nil];
}

@end
