//
// MSFAuthorizeViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAuthorizeViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "NSString+Matches.h"
#import "MSFClient.h"
#import "MSFUser.h"
#import "MSFUtils.h"
#import "MSFClient+Captcha.h"
#import "MSFClient+Users.h"
#import "NSString+Matches.h"
#import "NSDate+UTC0800.h"
#import <NSString-Hashes/NSString+Hashes.h>

NSString *const MSFAuthorizeErrorDomain = @"MSFAuthorizeErrorDomain";

static const int kCounterLength = 60;

const NSInteger MSFAuthorizeUsernameMaxLength = 11;
const NSInteger MSFAuthorizePasswordMaxLength = 16;
const NSInteger MSFAuthorizeIdentifierMaxLength = 18;
const NSInteger MSFAuthorizeCaptchaMaxLength = 4;
const NSInteger MSFAuthorizeNameMaxLength = 20;

NSString *const MSFAuthorizeCaptchaSignUp = @"REG";
NSString *const MSFAuthorizeCaptchaSignIn = @"LOGIN";
NSString *const MSFAuthorizeCaptchaLoan = @"LOAN";
NSString *const MSFAuthorizeCaptchaInitTransPassword = @"INIT_TRANS_PASSWORD";
NSString *const MSFAuthorizeCaptchaModifyTransPassword = @"MODIFY_TRANS_PASSWORD";
NSString *const MSFAuthorizeCaptchaForgetTransPassword = @"FORGET_TRANS_PASSWORD";
NSString *const MSFAuthorizeCaptchaForgetPassword = @"FORGET_PASSWORD";
NSString *const MSFAuthorizeCaptchaModifyMobile = @"MODIFY_MOBILE ";

@interface MSFAuthorizeViewModel ()

@property (nonatomic, assign) BOOL counting;
@property (nonatomic, strong, readwrite) RACSubject *signInInvalidSignal;

@end

@implementation MSFAuthorizeViewModel

#pragma mark - Lifecycle

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_username = @"";
	_password = @"";
	_captcha = @"";
	_counter = @"获取验证码";
	_agreeOnLicense = NO;
	_counting = NO;
	_signInValid = YES;
	_permanent = NO;
	_captchType = @"REG";
	_loginType = [[NSUserDefaults standardUserDefaults] boolForKey:@"install-boot"] ? MSFLoginSignIn :MSFLoginSignUp;
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"install-boot"];
	_captchaHighlightedImage = [[UIImage imageNamed:@"bg-send-captcha-highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 5) resizingMode:UIImageResizingModeStretch];
	_captchaNomalImage = [[UIImage imageNamed:@"bg-send-captcha"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 5) resizingMode:UIImageResizingModeStretch];
	
	@weakify(self)
	_executeSignIn = [[RACCommand alloc] initWithEnabled:self.signInValidSignal
		signalBlock:^RACSignal *(id input) {
			@strongify(self)
			return [self executeSignInSignal];
		}];
	
	_executeSignUp = [[RACCommand alloc] initWithEnabled:self.signUpValidSignal
		signalBlock:^RACSignal *(id input) {
			@strongify(self)
		 
			return [self executeSignUpSignal];
		}];
	
	_executeAgreeOnLicense = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		self.agreeOnLicense = !self.agreeOnLicense;
		
		return [RACSignal return:@(self.agreeOnLicense)];
	}];
	
	_executeCaptcha = [[RACCommand alloc] initWithEnabled:self.captchaRequestValidSignal signalBlock:^RACSignal *(id input) {
		@strongify(self)
		if (![self.username isMobile]) {
			return [RACSignal error:[self.class errorWithFailureReason:@"请填写正确的手机号"]];
		}
		return [[self executeCaptchaSignal]
			doNext:^(id x) {
				@strongify(self)
				self.counting = YES;
				RACSignal *repetitiveEventSignal = [[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:kCounterLength];
				__block int repetCount = kCounterLength;
				[repetitiveEventSignal subscribeNext:^(id x) {
					self.counter = [@(--repetCount) stringValue];
				} completed:^{
					self.counter = @"获取验证码";
					self.counting = NO;
				}];
			}];
		}];
	
	_executeCapthaTradePwd = [[RACCommand alloc] initWithEnabled:self.captchaRequestValidSignal signalBlock:^RACSignal *(id input) {
		@strongify(self)
		if (![self.username isMobile]) {
			return [RACSignal error:[self.class errorWithFailureReason:@"获取手机号失败"]];
		}
		return [[self executeCaptchaTradePwdSignal]
						doNext:^(id x) {
							@strongify(self)
							self.counting = YES;
							RACSignal *repetitiveEventSignal = [[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:kCounterLength];
							__block int repetCount = kCounterLength;
							[repetitiveEventSignal subscribeNext:^(id x) {
								self.counter = [@(--repetCount) stringValue];
							} completed:^{
								self.counter = @"获取验证码";
								self.counting = NO;
							}];
						}];
	}];

	_executeCaprchForgetTradePwd = [[RACCommand alloc] initWithEnabled:self.captchaRequestValidSignal signalBlock:^RACSignal *(id input) {
		@strongify(self)
		if (![self.username isMobile]) {
			return [RACSignal error:[self.class errorWithFailureReason:@"获取手机号失败"]];
		}
		return [[self executeCaptchForgetTradePwd]
						doNext:^(id x) {
							@strongify(self)
							self.counting = YES;
							RACSignal *repetitiveEventSignal = [[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:kCounterLength];
							__block int repetCount = kCounterLength;
							[repetitiveEventSignal subscribeNext:^(id x) {
								self.counter = [@(--repetCount) stringValue];
							} completed:^{
								self.counter = @"获取验证码";
								self.counting = NO;
							}];
						}];
	}];

	_executeCaptchUpdateTradePwd = [[RACCommand alloc] initWithEnabled:self.captchaRequestValidSignal signalBlock:^RACSignal *(id input) {
		@strongify(self)
		if (![self.username isMobile]) {
			return [RACSignal error:[self.class errorWithFailureReason:@"获取手机号失败"]];
		}
		return [[self executeCaptchaUpdateTradePwdSignal]
						doNext:^(id x) {
							@strongify(self)
							self.counting = YES;
							RACSignal *repetitiveEventSignal = [[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:kCounterLength];
							__block int repetCount = kCounterLength;
							[repetitiveEventSignal subscribeNext:^(id x) {
								self.counter = [@(--repetCount) stringValue];
							} completed:^{
								self.counter = @"获取验证码";
								self.counting = NO;
							}];
						}];
	}];

	
	_executeFindPassword = [[RACCommand alloc] initWithEnabled:self.findPasswordValidSignal
		signalBlock:^RACSignal *(id input) {
			@strongify(self)
		 
			return [self executeFindPasswordSignal];
		}];
	
	_executeFindPasswordCaptcha = [[RACCommand alloc] initWithEnabled:self.captchaRequestValidSignal
		signalBlock:^RACSignal *(id input) {
			@strongify(self)
			if (![self.username isMobile]) {
				return [RACSignal error:[self.class errorWithFailureReason:@"手机号获取失败"]];
			}
			return [[self executeFindPasswordCaptchaSignal] doNext:^(id x) {
				self.counting = YES;
				RACSignal *repetitiveEventSignal = [[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:kCounterLength];
				__block int repetCount = kCounterLength;
				[repetitiveEventSignal subscribeNext:^(id x) {
					 self.counter = [@(--repetCount) stringValue];
				} completed:^{
					self.counter = @"获取验证码";
					self.counting = NO;
				}];
			}];
		}];
	
	_executeSignOut = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [[MSFUtils.httpClient signOut] doNext:^(id x) {
			[MSFUtils setHttpClient:nil];
		}];
	}];
	
	_executeSetTradePwd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self executeSetTradepwdexecute];
	}];
	
	_executeUpdateTradePwd = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self updateTradeExecute];
	}];
	
	_executeUpdateSignInPassword = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		if (![self.usingSignInPasssword isPassword]) {
			return [RACSignal error:[NSError errorWithDomain:MSFAuthorizeErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:@"原密码错误"}]];
		}
		if (![self.updatingSignInPasssword isPassword]) {
			return [RACSignal error:[NSError errorWithDomain:MSFAuthorizeErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:@"请填写8~16位字母和数字组合的新密码"}]];
		}
		return [self updateSignInPasswordSignal];
  }];

	
	self.signInInvalidSignal = [[RACSubject subject] setNameWithFormat:@"`MSFAuthorizeViewModel signIn captcha required signal`"];
	
	return self;
}

#pragma mark - Public

- (RACSignal *)signInValidSignal {
	return [RACSignal
		combineLatest:@[
			RACObserve(self, username),
			RACObserve(self, password)
		]
		reduce:^id(NSString *username, NSString *password){
			return @(username!=nil && password != nil);
		}];
}

- (RACSignal *)signUpValidSignal {
	return [RACSignal
		combineLatest:@[
			RACObserve(self, username),
			RACObserve(self, password),
			RACObserve(self, captcha),
		]
		reduce:^id(NSString *username, NSString *password, NSString *captcha){
			return @(username != nil && password != nil && captcha != nil);
		}];
}

- (RACSignal *)captchaRequestValidSignal {
	return [RACSignal
		combineLatest:@[
			RACObserve(self, username),
			RACObserve(self, counting)
		]
		reduce:^id(NSString *username, NSNumber *counting){
			return @(username != nil && !counting.boolValue);
		}];
}

- (RACSignal *)findPasswordValidSignal {
	 return [RACSignal
		 combineLatest:@[
			 RACObserve(self, username),
			 RACObserve(self, password),
			 RACObserve(self, captcha),
		 ]
		 reduce:^id(NSString *username, NSString *password, NSString *captcha){
			 return @(username != nil && password != nil && captcha != nil);
		 }];
}

#pragma mark - Private

- (RACSignal *)executeSignInSignal {
	NSError *error;
	if (self.loginType == MSFLoginIDSignIn) {
	  if (![self.name isChineseName]||([self.name isChineseName] && (self.name.length < 2 || self.name.length > 20))) {
			NSString *str = @"请填写真实的姓名";
			if (self.name.length == 0) {
				str = @"请填写真实的姓名";
			}
			error = [NSError errorWithDomain:@"MSFAuthorizeViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: str,
			}];
			return [RACSignal error:error];
		}
		if (self.card.length != 18) {
			error = [NSError errorWithDomain:@"MSFAuthorizeViewModel" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请填写真实的身份证号码",
			}];
			return [RACSignal error:error];
		}
	} else {
		if (![self.username isMobile] || ![self.password isPassword]) {
			return [RACSignal error:[self.class errorWithFailureReason:@"手机号或密码错误，请重新填写"]];
		}
	}
	if (![self.password isPassword]) {
		return [RACSignal error:[self.class errorWithFailureReason:@"密码错误，请重新填写"]];
	}
	MSFUser *user = [MSFUser userWithServer:self.services.server];
	
	if (self.loginType == MSFLoginIDSignIn) {
	return [[[MSFClient
		signInAsUser:user username:self.name password:self.password citizenID:self.card]
		catch:^RACSignal *(NSError *error) {
			if ([error.userInfo[MSFClientErrorMessageCodeKey] isEqualToString:@"40012101"]) {
				_signInValid = NO;
				[(RACSubject *)self.signInInvalidSignal sendNext:nil];
			}
			return [RACSignal error:error];
		}]
		doNext:^(id x) {
			[MSFUtils setHttpClient:x];
		}];
	}
	return [[[MSFClient
		signInAsUser:user password:self.password phone:self.username captcha:self.captcha]
		catch:^RACSignal *(NSError *error) {
			if ([error.userInfo[MSFClientErrorMessageCodeKey] isEqualToString:@"40012101"]) {
				_signInValid = NO;
				[(RACSubject *)self.signInInvalidSignal sendNext:nil];
			}
			return [RACSignal error:error];
		}]
		doNext:^(MSFClient *client) {
			[MSFUtils setHttpClient:client];
			//MSFUser *user = client.user;
		}];
}

- (RACSignal *)executeSignUpSignal {
	NSError *error = nil;
	// 另外支持输入"."、"。"、"·"和"▪"。但是第一位和最后一位必须是汉字。
  if (![self.name isChineseName]||([self.name isChineseName] && (self.name.length < 2 || self.name.length > 20))) {
    NSString *str = @"请填写真实的姓名";
    if (self.name.length == 0) {
      str = @"请填写真实的姓名";
    }
    error = [NSError errorWithDomain:@"MSFAuthorizeViewModel" code:0 userInfo:@{
      NSLocalizedFailureReasonErrorKey: str,
      }];
    return [RACSignal error:error];
  }
	if (self.card.length != 18) {
		error = [NSError errorWithDomain:@"MSFAuthorizeViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请填写真实的身份证号码",
		}];
    return [RACSignal error:error];
	}
  if (!self.expired && !self.permanent ) {
    error = [NSError errorWithDomain:@"MSFAuthorizeViewModel" code:0 userInfo:@{
      NSLocalizedFailureReasonErrorKey: @"请填写真实的身份证有效期",
                                                                                    }];
    return [RACSignal error:error];
  }
	
	if (![self.username isMobile]) {
		return [RACSignal error:[self.class errorWithFailureReason:@"请填写真实的手机号码"]];
	} else if (![self.password isPassword]) {
		return [RACSignal error:[self.class errorWithFailureReason:@"请填写8到16位数字和字母组合的密码"]];
	} else if (![self.captcha isCaptcha]) {
		return [RACSignal error:[self.class errorWithFailureReason:@"请填写验证码"]];
	} else if (!self.agreeOnLicense) {
		return [RACSignal error:[self.class errorWithFailureReason:@"请阅读注册协议"]];
	}
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	NSDate *expiredDate = self.permanent ? [NSDate msf_date:[dateFormatter dateFromString:@"2099-12-31"]]: self.expired;
	
	MSFUser *user = [MSFUser userWithServer:self.services.server];
	return [[MSFClient
		signUpAsUser:user password:self.password phone:self.username captcha:self.captcha realname:self.name citizenID:self.card citizenIDExpiredDate:expiredDate]
		doNext:^(id x) {
			[MSFUtils setHttpClient:x];
		}];
}

- (RACSignal *)executeCaptchaSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:self.services.server];
	return [client fetchSignUpCaptchaWithPhone:self.username];
}

- (RACSignal *)executeCaptchaTradePwdSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:self.services.server];
	return [client fetchLoginCaptchaTradeWithPhone:self.username];
}

- (RACSignal *)executeCaptchaUpdateTradePwdSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:self.services.server];
	return [client fetchCapthchaUpdateTradeWithPhone:self.username];
}

- (RACSignal *)executeCaptchForgetTradePwd {
	MSFClient *client = [[MSFClient alloc] initWithServer:self.services.server];
	return [client fetchLoginCaptchaForgetTradeWithPhone:self.username];
}

- (RACSignal *)executeFindPasswordSignal {
	NSError *error;
	if (![self.name isChineseName]||([self.name isChineseName] && (self.name.length < 2 || self.name.length > 20))) {
		NSString *str = @"请填写真实的姓名";
		if (self.name.length == 0) {
			str = @"请填写真实的姓名";
		}
		error = [NSError errorWithDomain:@"MSFAuthorizeViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: str,
		}];
		return [RACSignal error:error];
	}
	if (self.card.length != 18) {
		error = [NSError errorWithDomain:@"MSFAuthorizeViewModel" code:0 userInfo:@{
			NSLocalizedFailureReasonErrorKey: @"请填写真实的身份证号码",
		}];
		return [RACSignal error:error];
	}
	if (![self.username isMobile]) {
		return [RACSignal error:[self.class errorWithFailureReason:@"请填写真实的手机号码"]];
	} else if (![self.password isPassword]) {
		return [RACSignal error:[self.class errorWithFailureReason:@"请填写8到16位数字和字母组合的密码"]];
	} else if (![self.captcha isCaptcha]) {
		return [RACSignal error:[self.class errorWithFailureReason:@"请填写验证码"]];
	}
	MSFClient *client = [[MSFClient alloc] initWithServer:self.services.server];
	return [client resetSignInPassword:self.password phone:self.username captcha:self.captcha name:self.name citizenID:self.card];
}

- (RACSignal *)executeFindPasswordCaptchaSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:self.services.server];
	return [client fetchResetPasswordCaptchaWithPhone:self.username];
}

+ (NSError *)errorWithFailureReason:(NSString *)string {
	return [NSError errorWithDomain:MSFAuthorizeErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:string}];
}

- (RACSignal *)executeSetTradepwdexecute {
	
	NSError *error;
		if (self.TradePassword.length == 0) {
			NSString *str = @"请填写交易密码";
			error = [NSError errorWithDomain:@"MSFAuthorizeViewModel" code:0 userInfo:@{
																																									NSLocalizedFailureReasonErrorKey: str,
																																									}];
			return [RACSignal error:error];
		}
	if (self.smsCode.length == 0) {
		NSString *str = @"请填写验证码";
		error = [NSError errorWithDomain:@"MSFAuthorizeViewModel" code:0 userInfo:@{
																																								NSLocalizedFailureReasonErrorKey: str,
																																								}];
		return [RACSignal error:error];
	}
	
	if (self.againTradePWD.length == 0) {
		NSString *str = @"请填写确认交易密码";
		error = [NSError errorWithDomain:@"MSFAuthorizeViewModel" code:0 userInfo:@{
																																								NSLocalizedFailureReasonErrorKey: str,
																																								}];
		return [RACSignal error:error];
	}
	if (![self.againTradePWD isEqualToString:self.TradePassword]) {
		NSString *str = @"交易密码和确认交易密码不一致";
		error = [NSError errorWithDomain:@"MSFAuthorizeViewModel" code:0 userInfo:@{
																																								NSLocalizedFailureReasonErrorKey: str,
																																								}];
		return [RACSignal error:error];
	}


	return [self.services.httpClient setTradePwdWithPWD:self.TradePassword.sha256 AndCaptch:self.smsCode];
}

- (RACSignal *)updateTradeExecute {
	
	NSError *error;
	if (self.oldTradePWD.length == 0) {
		NSString *str = @"请填写旧交易密码";
		error = [NSError errorWithDomain:@"MSFAuthorizeViewModel" code:0 userInfo:@{
																																								NSLocalizedFailureReasonErrorKey: str,
																																								}];
		return [RACSignal error:error];
	}
	if (self.TradePassword.length == 0) {
		NSString *str = @"请填写新交易密码";
		error = [NSError errorWithDomain:@"MSFAuthorizeViewModel" code:0 userInfo:@{
																																								NSLocalizedFailureReasonErrorKey: str,
																																								}];
		return [RACSignal error:error];
	}
	if (self.againTradePWD.length == 0) {
		NSString *str = @"请填写确认新交易密码";
		error = [NSError errorWithDomain:@"MSFAuthorizeViewModel" code:0 userInfo:@{
																																								NSLocalizedFailureReasonErrorKey: str,
																																								}];
		return [RACSignal error:error];
	}
	
	if (![self.againTradePWD isEqualToString:self.TradePassword]) {
		NSString *str = @"新交易密码和确认新交易密码不一致";
		error = [NSError errorWithDomain:@"MSFAuthorizeViewModel" code:0 userInfo:@{
																																								NSLocalizedFailureReasonErrorKey: str,
																																								}];
		return [RACSignal error:error];
	}
	
	return [self.services.httpClient updateTradePwdWitholdPwd:self.oldTradePWD.sha256 AndNewPwd:self.TradePassword.sha256 AndCaptch:self.smsCode];
}

- (RACSignal *)updateSignInPasswordSignal {
	return [self.services.httpClient updateSignInPassword:self.usingSignInPasssword password:self.updatingSignInPasssword];
}

@end
