//
// MSFAuthorizeViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFLoginSwapController.h"
#import "MSFViewModelServices.h"

@class MSFServer;
@class RACCommand;

extern NSString *const MSFAuthorizeErrorDomain;

@interface MSFAuthorizeViewModel : RVMViewModel

@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, assign) MSFLoginType loginType;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) RACCommand *executeSignIn;
@property (nonatomic, strong) RACCommand *executeSignUp;
@property (nonatomic, strong) RACCommand *executeSignOut;

@property (nonatomic, assign) BOOL agreeOnLicense;
@property (nonatomic, strong) RACCommand *executeAgreeOnLicense;

@property (nonatomic, strong) NSString *counter;
@property (nonatomic, strong) NSString *captcha;
@property (nonatomic, strong) RACCommand *executeCaptcha;

@property (nonatomic, strong) RACCommand *executeFindPassword;
@property (nonatomic, strong) RACCommand *executeFindPasswordCaptcha;

@property (nonatomic, strong) RACCommand *executeLoginCaptcha;

- (RACSignal *)signInValidSignal;
- (RACSignal *)signUpValidSignal;
- (RACSignal *)findPasswordValidSignal;
- (RACSignal *)captchaRequestValidSignal;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
