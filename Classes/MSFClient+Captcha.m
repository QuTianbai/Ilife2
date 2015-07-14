//
// MSFClient+Captcha.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Captcha.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>

@implementation MSFClient (Captcha)

- (RACSignal *)fetchSignUpCaptchaWithPhone:(NSString *)phone {
	NSString *path = [NSString stringWithFormat:@"captcha/%@/register",phone];
	NSURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:nil];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)fetchResetPasswordCaptchaWithPhone:(NSString *)phone {
	NSString *path = [NSString stringWithFormat:@"captcha/%@/forget_password",phone];
	NSURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:nil];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)fetchLoginCaptchaWithPhone:(NSString *)phone {
	NSString *path = [NSString stringWithFormat:@"captcha/%@/login",phone];
	NSURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:nil];
	
	return [self enqueueRequest:request resultClass:nil];
}

@end
