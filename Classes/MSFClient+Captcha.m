//
// MSFClient+Captcha.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Captcha.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFAuthorizeViewModel.h"

@implementation MSFClient (Captcha)

- (RACSignal *)fetchSignUpCaptchaWithPhone:(NSString *)phone {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"system/smssecurity" parameters:@{
		@"codeType": @"REG",
		@"mobile": phone
	}];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)fetchResetPasswordCaptchaWithPhone:(NSString *)phone {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"system/smssecurity" parameters:@{
		@"codeType": @"FORGET_PASSWORD",
		@"mobile": phone
	}];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)fetchLoginCaptchaWithPhone:(NSString *)phone {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"system/smssecurity" parameters:@{
		@"codeType": @"LOGIN",
		@"mobile": phone
	}];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)fetchLoginCaptchaTradeWithPhone:(NSString *)phone {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"system/smssecurity" parameters: @{
		@"codeType": @"INIT_TRANS_PASSWORD",
		@"mobile": phone
	}];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)fetchLoginCaptchaForgetTradeWithPhone:(NSString *)phone {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"system/smssecurity" parameters: @{
		@"codeType": @"FORGET_TRANS_PASSWORD",
		@"mobile": phone
	}];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)fetchCapthchaUpdateTradeWithPhone:(NSString *)phone {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"system/smssecurity" parameters:@{
		@"codeType": @"MODIFY_TRANS_PASSWORD",
		@"mobile": phone
	}];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)fetchAlertMobileCaptchaWithPhone:(NSString *)phone {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"system/smssecurity" parameters:@{
		@"codeType": @"MODIFY_MOBILE",
		@"mobile": phone
	}];
	
	return [self enqueueRequest:request resultClass:nil];
}

- (RACSignal *)fetchPaySmsCodeWithPhone:(NSString *)phone {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"system/smssecurity" parameters: @{
																																																 @"codeType": @"INIT_TRANS_PASSWORD",
																																																 @"mobile": phone
																																																 }];
	
	return [self enqueueRequest:request resultClass:nil];
}

@end
