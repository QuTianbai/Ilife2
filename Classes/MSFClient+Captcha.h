//
// MSFClient+Captcha.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (Captcha)

/**
 *	获取注册验证
 *
 *	@param phone
 *
 *	@return response
 */
- (RACSignal *)fetchSignUpCaptchaWithPhone:(NSString *)phone;

/**
 *	获取找回密码验证码
 *
 *	@param phone
 *
 *	@return response
 */
- (RACSignal *)fetchResetPasswordCaptchaWithPhone:(NSString *)phone;

- (RACSignal *)fetchLoginCaptchaWithPhone:(NSString *)phone;

- (RACSignal *)fetchLoginCaptchaTradeWithPhone:(NSString *)phone;

- (RACSignal *)fetchLoginCaptchaForgetTradeWithPhone:(NSString *)phone;

@end
