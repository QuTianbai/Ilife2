//
// MSFAuthorizeViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

typedef NS_ENUM(NSUInteger, MSFLoginType) {
	MSFLoginSignUp,
	MSFLoginSignIn,
};

@class MSFServer;
@class RACCommand;
@class MSFIntergrant;

// 授权接口调用错误域
extern NSString *const MSFAuthorizeErrorDomain;

// 授权ViewModel
//
// 登录/注册/找回密码 ViewModel
@interface MSFAuthorizeViewModel : RVMViewModel

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

// Request server find password
@property (nonatomic, strong) RACCommand *executeFindPassword;

// Request server send find password capcha command
@property (nonatomic, strong) RACCommand *executeFindPasswordCaptcha;

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
- (instancetype)initWithServices:(id <MSFViewModelServices>)services upgrade:(MSFIntergrant *)upgrade;


@property (nonatomic, readonly) MSFIntergrant *upgrade;
@property (nonatomic, readonly) BOOL isUpgrade;

@end
