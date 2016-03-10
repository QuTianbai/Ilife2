//
// MSFAuthorizeViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MSFLoginType) {
	MSFLoginSignUp,
	MSFLoginSignIn,
	MSFLoginIDSignIn,
	MSFLoginAlterMobile,
};

extern NSString *const MSFAuthorizeCaptchaSignUp;
extern NSString *const MSFAuthorizeCaptchaSignIn;
extern NSString *const MSFAuthorizeCaptchaLoan;
extern NSString *const MSFAuthorizeCaptchaInitTransPassword;
extern NSString *const MSFAuthorizeCaptchaModifyTransPassword;
extern NSString *const MSFAuthorizeCaptchaForgetTransPassword;
extern NSString *const MSFAuthorizeCaptchaForgetPassword;
extern NSString *const MSFAuthorizeCaptchaModifyMobile;

@class MSFServer;
@class RACCommand;
@class MSFAddressCodes;

extern const NSInteger MSFAuthorizeUsernameMaxLength;
extern const NSInteger MSFAuthorizePasswordMaxLength;
extern const NSInteger MSFAuthorizeIdentifierMaxLength;
extern const NSInteger MSFAuthorizeCaptchaMaxLength;
extern const NSInteger MSFAuthorizeNameMaxLength;

// 授权接口调用错误域
extern NSString *const MSFAuthorizeErrorDomain;

// 授权ViewModel
//
// 登录/注册/找回密码 ViewModel
@interface MSFAuthorizeViewModel : RVMViewModel

//发送验证码类型
@property (nonatomic, copy) NSString *captchType;

//交易密码
@property (nonatomic, copy) NSString *TradePassword;
@property (nonatomic, copy) NSString *againTradePWD;
@property (nonatomic, copy) NSString *smsCode;

@property (nonatomic, copy) NSString *oldTradePWD;

@property (nonatomic, weak) id <MSFViewModelServices> services;

// 动态改变授权ViewModel的状态，根据不同的状态来影响登录/注册控制界面的显示
//
// 这个参数会对是否第一次启动APP做缓存处理
// 第一次启动APP默认到注册状态，非第一次进入APP默认到登录状态
@property (nonatomic, assign) MSFLoginType loginType;

// signin/signup/findpassword use username, Only phone numbers
@property (nonatomic, strong) NSString *username;

// signup/signin use password
@property (nonatomic, strong) NSString *password;

// Signup/Signin send captcha code tip label, default `获取验证码`
@property (nonatomic, strong) NSString *counter;

// Signin/Signup six bit captcha code
@property (nonatomic, strong) NSString *captcha;

// Bool value, agree signup license
@property (nonatomic, assign) BOOL agreeOnLicense;

// Request signin command
@property (nonatomic, strong) RACCommand *executeSignIn;

// Request signup command
@property (nonatomic, strong) RACCommand *executeSignUp;

// Request signout command
@property (nonatomic, strong) RACCommand *executeSignOut;

// Agreee signup license command
@property (nonatomic, strong) RACCommand *executeAgreeOnLicense;

// Request server send signup captcha command
@property (nonatomic, strong) RACCommand *executeCaptcha;

@property (nonatomic, strong) RACCommand *executeCapthaTradePwd;

@property (nonatomic, strong) RACCommand *executeCaprchForgetTradePwd;

@property (nonatomic, strong) RACCommand *executeCaptchUpdateTradePwd;

@property (nonatomic, strong) RACCommand *executeCaptchaAlterMobile;
@property (nonatomic, strong) RACCommand *executeAlterMobile;

// Request server find password
@property (nonatomic, strong) RACCommand *executeFindPassword;
@property (nonatomic, strong) RACCommand *executeFindPasswordCaptcha;

@property (nonatomic, strong) RACCommand *executeSetTradePwd;
@property (nonatomic, strong) RACCommand *executeUpdateTradePwd;

@property (nonatomic, strong) RACCommand *executePayCommand;

@property (nonatomic, strong) RACCommand *executeSignInCommand;
@property (nonatomic, strong) RACCommand *executeSignUpCommand;

@property (nonatomic, strong, readonly) RACCommand *executeAuthenticateCommand;
@property (nonatomic, strong, readonly) RACCommand *executeAlterAddressCommand;
@property (nonatomic, strong, readonly) NSString *address;
@property (nonatomic, strong) NSString *banknumber;


- (RACSignal *)signInValidSignal;
- (RACSignal *)signUpValidSignal;
- (RACSignal *)findPasswordValidSignal;
- (RACSignal *)captchaRequestValidSignal;

// Create MSFAuthorizeViewModel instance
//
// services - provide `server` to create client
//
// Return a new MSFAuthorizeViewModel instance
- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@property (nonatomic, assign, readonly) BOOL signInValid;
@property (nonatomic, strong, readonly) RACSignal *signInInvalidSignal;

@property (nonatomic, strong) UIImage *captchaNomalImage;
@property (nonatomic, strong) UIImage *captchaHighlightedImage;

// The User realname, Identifier Card name
@property (nonatomic, strong) NSString *name;

// identfier Card no∑
@property (nonatomic, strong) NSString *card;

// The identifer Card invalid time
@property (nonatomic, strong) NSDate *expired;

// User Identifier card is or not life time valid
@property (nonatomic, assign) BOOL permanent;

@property (nonatomic, strong) NSString *usingMobile;
@property (nonatomic, strong) NSString *updatingMobile;

@property (nonatomic, strong) NSString *usingSignInPasssword;
@property (nonatomic, strong) NSString *updatingSignInPasssword;
@property (nonatomic, strong) RACCommand *executeUpdateSignInPassword;

@end
