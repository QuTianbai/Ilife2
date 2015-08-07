//
// NSURLRequest+RequestWithIgnoreSSL.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "NSURLRequest+RequestWithIgnoreSSL.h"

@implementation NSURLRequest (RequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
	return YES; 
} 

@end
