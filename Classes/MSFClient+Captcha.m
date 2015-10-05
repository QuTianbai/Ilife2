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
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"smssecurity/send" parameters:@{
		@"codeType": @"REG",
		@"mobile": phone
	}];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)fetchResetPasswordCaptchaWithPhone:(NSString *)phone {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"smssecurity/send" parameters:@{
		@"codeType": @"FORGET_TRANS_PASSWORD",
		@"mobile": phone
	}];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)fetchLoginCaptchaWithPhone:(NSString *)phone {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"smssecurity/send" parameters:@{
		@"codeType": @"LOGIN",
		@"mobile": phone
	}];
	
	return [self enqueueRequest:request resultClass:nil];
}

@end
