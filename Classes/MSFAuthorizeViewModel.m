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

NSString *const MSFAuthorizeErrorDomain = @"MSFAuthorizeErrorDomain";

static const int kCounterLength = 60;

@interface MSFAuthorizeViewModel ()

@property (nonatomic, assign) BOOL counting;

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
	_counter = @"发送验证码";
	_agreeOnLicense = NO;
	_counting = NO;
	
	@weakify(self)
	_executeSignIn = [[RACCommand alloc] initWithEnabled:self.signInValidSignal
		signalBlock:^RACSignal *(id input) {
			@strongify(self)
			if (![self.username isMobile]) {
				return [RACSignal error:[self.class errorWithFailureReason:@"请输入正确的手机号"]];
			} else if (![self.password isPassword]) {
				return [RACSignal error:[self.class errorWithFailureReason:@"请输入8位以上数字和字母混合密码"]];
			}
		 
			return [self executeSignInSignal];
		}];
	
	_executeSignUp = [[RACCommand alloc] initWithEnabled:self.signUpValidSignal
		signalBlock:^RACSignal *(id input) {
			@strongify(self)
			if (![self.username isMobile]) {
				return [RACSignal error:[self.class errorWithFailureReason:@"请输入正确的手机号"]];
			} else if (![self.captcha isCaptcha]) {
				return [RACSignal error:[self.class errorWithFailureReason:@"请输入6位验证码"]];
			} else if (![self.password isPassword]) {
				return [RACSignal error:[self.class errorWithFailureReason:@"请输入8位以上数字和字母混合密码"]];
			} else if (!self.agreeOnLicense) {
				return [RACSignal error:[self.class errorWithFailureReason:@"请仔细阅读贷款协议"]];
			}
		 
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
			return [RACSignal error:[self.class errorWithFailureReason:@"请输入正确的手机号"]];
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
					self.counter = @"发送验证码";
					self.counting = NO;
				}];
			}];
		}];
	
	_executeFindPassword = [[RACCommand alloc] initWithEnabled:self.findPasswordValidSignal
		signalBlock:^RACSignal *(id input) {
			@strongify(self)
			if (![self.username isMobile]) {
				return [RACSignal error:[self.class errorWithFailureReason:@"请输入正确的手机号"]];
			} else if (![self.captcha isCaptcha]) {
				return [RACSignal error:[self.class errorWithFailureReason:@"请输入6位验证码"]];
			} else if (![self.password isPassword]) {
				return [RACSignal error:[self.class errorWithFailureReason:@"请输入8位以上数字和字母混合密码"]];
			}
		 
			return [self executeFindPasswordSignal];
		}];
	
	_executeFindPasswordCaptcha = [[RACCommand alloc] initWithEnabled:self.captchaRequestValidSignal
		signalBlock:^RACSignal *(id input) {
			@strongify(self)
			if (![self.username isMobile]) {
				return [RACSignal error:[self.class errorWithFailureReason:@"请输入正确的手机号"]];
			}
			return [[self executeFindPasswordCaptchaSignal] doNext:^(id x) {
				self.counting = YES;
				RACSignal *repetitiveEventSignal = [[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:kCounterLength];
				__block int repetCount = kCounterLength;
				[repetitiveEventSignal subscribeNext:^(id x) {
					 self.counter = [@(--repetCount) stringValue];
				} completed:^{
					self.counter = @"发送验证码";
					self.counting = NO;
				}];
			}];
		}];
	
	_executeSignOut = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [[MSFUtils.httpClient signOut] doNext:^(id x) {
			[MSFUtils setHttpClient:nil];
		}];
	}];
	
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
	MSFUser *user = [MSFUser userWithServer:self.services.server];
	return [[MSFClient
		signInAsUser:user password:self.password phone:self.username captcha:self.captcha]
		doNext:^(id x) {
			[MSFUtils setHttpClient:x];
		}];
}

- (RACSignal *)executeSignUpSignal {
	MSFUser *user = [MSFUser userWithServer:self.services.server];
	return [[MSFClient
		signUpAsUser:user password:self.password phone:self.username captcha:self.captcha]
		doNext:^(id x) {
			[MSFUtils setHttpClient:x];
		}];
}

- (RACSignal *)executeCaptchaSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:self.services.server];
	return [client fetchSignUpCaptchaWithPhone:self.username];
}

- (RACSignal *)executeFindPasswordSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:self.services.server];
	return [client resetPassword:self.password phone:self.username captcha:self.captcha];
}

- (RACSignal *)executeFindPasswordCaptchaSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:self.services.server];
	return [client fetchResetPasswordCaptchaWithPhone:self.username];
}

- (RACSignal *)executeLoginCaptchaSignal {
	MSFClient *client = [[MSFClient alloc] initWithServer:self.services.server];
	return [client fetchLoginCaptchaWithPhone:self.username];
}

+ (NSError *)errorWithFailureReason:(NSString *)string {
	return [NSError errorWithDomain:MSFAuthorizeErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:string}];
}

@end
