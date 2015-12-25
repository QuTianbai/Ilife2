//
// MSFClient+Captcha.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (Captcha)

// 获取注册验证
//
// Returns response
- (RACSignal *)fetchSignUpCaptchaWithPhone:(NSString *)phone;

// 获取用户更改手机号验证码
- (RACSignal *)fetchAlertMobileCaptchaWithPhone:(NSString *)phone;

// 获取找回密码验证码
//
// Returns response
- (RACSignal *)fetchResetPasswordCaptchaWithPhone:(NSString *)phone;

// 获取用户登录验证码
//
// 当用户在与上一次不同的设备上登录的时候需要通过验证码登录
//
// phone - 用户登录手机号
//
// Returns signal 200 response
- (RACSignal *)fetchLoginCaptchaWithPhone:(NSString *)phone;

// 获取用户设置交易密码验证码
- (RACSignal *)fetchLoginCaptchaTradeWithPhone:(NSString *)phone;

// 用户用户更新交易密码验证码
- (RACSignal *)fetchCapthchaUpdateTradeWithPhone:(NSString *)phone;

// 获取用户忘记交易密码验证码
- (RACSignal *)fetchLoginCaptchaForgetTradeWithPhone:(NSString *)phone;

//获取支付验证
- (RACSignal *)fetchPaySmsCodeWithPhone:(NSString *)phone;
@end
