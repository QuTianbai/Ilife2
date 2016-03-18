//
// MSFAuthorizeViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAuthorizeViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "NSString+Matches.h"
#import "MSFClient.h"
#import "MSFUser.h"
#import "MSFClient+Captcha.h"
#import "MSFClient+Users.h"
#import "NSString+Matches.h"
#import "NSDate+UTC0800.h"
#import <NSString-Hashes/NSString+Hashes.h>
#import "MSFServer.h"
#import "MSFAddressCodes.h"
#import "MSFAddressViewModel.h"
#import "MSFGetBankIcon.h"
#import "MSFBankInfoModel.h"
#import <FMDB/FMDB.h>
#import "MSFAuthenticate.h"
#import "MSFUser.h"

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
@property (nonatomic, strong) MSFAddressViewModel *addressViewModel;
@property (nonatomic, strong, readwrite) RACCommand *executeAlterAddressCommand;
@property (nonatomic, strong) MSFBankInfoModel *bankInfo;
@property (nonatomic, strong) NSString *oldBankNo;
@property (nonatomic, strong) FMDatabase *fmdb;

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
	NSString *path = [[NSBundle mainBundle] pathForResource:@"bank" ofType:@"db"];
	_fmdb = [[FMDatabase alloc] initWithPath:path];
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
				RACSignal *repetitiveEventSignal = [[[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:kCounterLength] takeUntil:self.didBecomeInactiveSignal];
				__block int repetCount = kCounterLength;
				[repetitiveEventSignal subscribeNext:^(id x) {
					self.counter = [@(--repetCount) stringValue];
				} completed:^{
					self.counter = @"获取验证码";
					self.counting = NO;
				}];
			}];
		}];
	_executeCaptchaAlterMobile = [[RACCommand alloc] initWithEnabled:self.captchaRequestValidSignal signalBlock:^RACSignal *(id input) {
		@strongify(self)
		if (![self.updatingMobile isMobile]) {
			return [RACSignal error:[self.class errorWithFailureReason:@"请填写正确的手机号"]];
		}
		return [[self executeCaptchaAlertMobileSignal]
			doNext:^(id x) {
				@strongify(self)
				self.counting = YES;
				RACSignal *repetitiveEventSignal = [[[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:kCounterLength] takeUntil:self.didBecomeInactiveSignal];
				__block int repetCount = kCounterLength;
				[repetitiveEventSignal subscribeNext:^(id x) {
					self.counter = [@(--repetCount) stringValue];
				} completed:^{
					self.counter = @"获取验证码";
					self.counting = NO;
				}];
			}];
		}];
	
	_executeAlterMobile = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self executeAlterMobileSignal];
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
				RACSignal *repetitiveEventSignal = [[[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:kCounterLength] takeUntil:self.didBecomeInactiveSignal];
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
				RACSignal *repetitiveEventSignal = [[[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:kCounterLength] takeUntil:self.didBecomeInactiveSignal];
				__block int repetCount = kCounterLength;
				[repetitiveEventSignal subscribeNext:^(id x) {
					self.counter = [@(--repetCount) stringValue];
				}
				completed:^{
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
				RACSignal *repetitiveEventSignal = [[[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:kCounterLength] takeUntil:self.didBecomeInactiveSignal];
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
				RACSignal *repetitiveEventSignal = [[[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:kCounterLength] takeUntil:self.didBecomeInactiveSignal];
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
		return [self.services.httpClient signOut];
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
	
	_executePayCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		if (![self.username isMobile]) {
			return [RACSignal error:[self.class errorWithFailureReason:@"获取手机号失败"]];
		}
		return [[self executePaySignal]
						doNext:^(id x) {
							@strongify(self)
							self.counting = YES;
							RACSignal *repetitiveEventSignal = [[[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:kCounterLength] takeUntil:self.didBecomeInactiveSignal];
							__block int repetCount = kCounterLength;
							[repetitiveEventSignal subscribeNext:^(id x) {
								self.counter = [@(--repetCount) stringValue];
							} completed:^{
								self.counter = @"获取验证码";
								self.counting = NO;
							}];
						}];
	}];
	
	_executeSignInCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		self.loginType = MSFLoginSignIn;
		[self.services presentViewModel:self];
		return [RACSignal return:nil];
	}];
	_executeSignUpCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		self.loginType = MSFLoginSignUp;
		[self.services pushViewModel:self];
		return [RACSignal return:nil];
	}];
	
	_addressViewModel = [[MSFAddressViewModel alloc] initWithServices:self.services];
	RAC(self, address) = RACObserve(self, addressViewModel.address);
	self.executeAlterAddressCommand = self.addressViewModel.selectCommand;
	
	_executeAuthenticateCommand = [[RACCommand alloc] initWithEnabled:[self authenticateValidSignal] signalBlock:^RACSignal *(id input) {
		return [self authenticateSignal];
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

- (RACSignal *)authenticateValidSignal {
	return [RACSignal combineLatest:@[RACObserve(self.addressViewModel, provinceCode), RACObserve(self.addressViewModel, cityCode), RACObserve(self, username), RACObserve(self, card), RACObserve(self, banknumber)] reduce:^id (NSString *province, NSString *city, NSString *username, NSString *card, NSString *number) {
		return @(province.length > 0 && city.length > 0 && username.length > 0 && card.length > 0 && number.length > 0);
	}];
}

- (RACSignal *)authenticateSignal {
	return [[self.services.httpClient authenticateUsername:self.username userident:self.card city:self.addressViewModel.cityCode province:self.addressViewModel.provinceCode banknumber:self.banknumber]
		doNext:^(MSFAuthenticate *auth) {
			MSFClient *client = self.services.httpClient;
			MSFUser *user = [[MSFUser alloc] initWithDictionary:@{
				@keypath(MSFUser.new, uniqueId): auth.uniqueId?:@"",
				@keypath(MSFUser.new, name): auth.name?:@"",
				@keypath(MSFUser.new, hasChecked): @"1"
			} error:nil];
//			[client.user mergeValueForKey:@keypath(MSFUser.new, uniqueId) fromModel:user];
            client.user.name = user.name;
            client.user.hasChecked = user.hasChecked;
            client.user.uniqueId = user.uniqueId;
//			[client.user mergeValueForKey:@keypath(MSFUser.new, hasChecked) fromModel:user];
			[client.fetchUserInfo subscribeNext:^(MSFUser *x) {
				[client.user mergeValueForKey:@keypath(x.personal) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.professional) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.contacts) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.profiles) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.insurance) fromModel:x];
			}];
		}];
}

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
	MSFUser *user = [MSFUser userWithServer:MSFServer.dotComServer];
	
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
		doNext:^(MSFClient *client) {
			[self.services setHttpClient:client];
			[[client fetchUserInfo] subscribeNext:^(MSFUser *x) {
				[client.user mergeValueForKey:@keypath(x.personal) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.professional) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.contacts) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.profiles) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.insurance) fromModel:x];
			}];
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
			_signInValid = YES;
			[self.services setHttpClient:client];
			[[client fetchUserInfo] subscribeNext:^(MSFUser *x) {
				[client.user mergeValueForKey:@keypath(x.personal) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.professional) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.contacts) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.profiles) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.insurance) fromModel:x];
			}];
		}];
}

- (RACSignal *)executeSignUpSignal {
	if (![self.username isMobile]) {
		return [RACSignal error:[self.class errorWithFailureReason:@"请填写真实的手机号码"]];
	} else if (![self.password isPassword]) {
		return [RACSignal error:[self.class errorWithFailureReason:@"请填写8到16位数字和字母组合的密码"]];
	} else if (![self.captcha isCaptcha]) {
		return [RACSignal error:[self.class errorWithFailureReason:@"请填写验证码"]];
	} else if (!self.agreeOnLicense) {
		return [RACSignal error:[self.class errorWithFailureReason:@"请阅读注册协议"]];
	}
	
	MSFUser *user = [MSFUser userWithServer:MSFServer.dotComServer];
	return [[MSFClient
		signUpAsUser:user password:self.password phone:self.username captcha:self.captcha]
		doNext:^(MSFClient *client) {
			_signInValid = YES;
			[self.services setHttpClient:client];
			[[client fetchUserInfo] subscribeNext:^(MSFUser *x) {
				[client.user mergeValueForKey:@keypath(x.personal) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.professional) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.contacts) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.profiles) fromModel:x];
				[client.user mergeValueForKey:@keypath(x.insurance) fromModel:x];
			}];
		}];
}

- (RACSignal *)executeCaptchaSignal {
	if (self.loginType == MSFLoginSignUp) {
		return [self.services.httpClient fetchSignUpCaptchaWithPhone:self.username];
	} else {
		return [self.services.httpClient fetchLoginCaptchaWithPhone:self.username];
	}
}

- (RACSignal *)executeCaptchaAlertMobileSignal {
	return [self.services.httpClient fetchAlertMobileCaptchaWithPhone:self.updatingMobile];
}

- (RACSignal *)executeAlterMobileSignal {
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
	
	if (![self.usingMobile isMobile]) {
		return [RACSignal error:[self.class errorWithFailureReason:@"请填写正确的旧手机号码"]];
	} else if (![self.updatingMobile isMobile]) {
		return [RACSignal error:[self.class errorWithFailureReason:@"请填写正确的新手机号码"]];
	} else if (![self.captcha isCaptcha]) {
		return [RACSignal error:[self.class errorWithFailureReason:@"请填写验证码"]];
	}
	return [[self.services.httpClient associateSignInMobile:self.updatingMobile usingMobile:self.usingMobile captcha:self.captcha citizenID:self.card name:self.name] doNext:^(MSFClient *client) {
		[self.services setHttpClient:client];
		[[client fetchUserInfo] subscribeNext:^(MSFUser *x) {
			[client.user mergeValueForKey:@keypath(x.personal) fromModel:x];
			[client.user mergeValueForKey:@keypath(x.professional) fromModel:x];
			[client.user mergeValueForKey:@keypath(x.contacts) fromModel:x];
			[client.user mergeValueForKey:@keypath(x.profiles) fromModel:x];
			[client.user mergeValueForKey:@keypath(x.insurance) fromModel:x];
		}];
	}];
}

- (RACSignal *)executeCaptchaTradePwdSignal {
	return [self.services.httpClient fetchLoginCaptchaTradeWithPhone:self.username];
}

- (RACSignal *)executeCaptchaUpdateTradePwdSignal {
	return [self.services.httpClient fetchCapthchaUpdateTradeWithPhone:self.username];
}

- (RACSignal *)executeCaptchForgetTradePwd {
	return [self.services.httpClient fetchLoginCaptchaForgetTradeWithPhone:self.username];
}

- (RACSignal *)executePaySignal {
	return [self.services.httpClient fetchLoginCaptchaTradeWithPhone:self.username];
}

- (RACSignal *)executeFindPasswordSignal {
	if (!self.username.isMobile) {
		return [RACSignal error:[NSError errorWithDomain:MSFAuthorizeErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请输入正确的手机号"}]];
	}
	if (self.captcha.length != 4) {
		return [RACSignal error:[NSError errorWithDomain:MSFAuthorizeErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请输入正确的验证码"}]];
	}

	return [self.services.httpClient resetSignInPassword:self.password phone:self.username captcha:self.captcha name:self.name citizenID:self.card];
}

- (RACSignal *)executeFindPasswordCaptchaSignal {
	return [self.services.httpClient fetchResetPasswordCaptchaWithPhone:self.username];
}

+ (NSError *)errorWithFailureReason:(NSString *)string {
	return [NSError errorWithDomain:MSFAuthorizeErrorDomain code:0 userInfo:@{
		NSLocalizedFailureReasonErrorKey: string
	}];
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
	if ([self.TradePassword isSimplePWD]) {
		NSString *str = @"交易密码设置太简单，请重新输入";
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
	
	if ([self.TradePassword isSimplePWD]) {
		NSString *str = @"交易密码设置太简单，请重新输入";
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

- (RACSignal *)searchUserIdWithNumber:(NSString *)number {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *tempBankNo = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if (number.length == 0) [subscriber sendNext:RACTuplePack(nil, @"")];
        
        for (int i = 0; i < tempBankNo.length; i ++) {
            NSString *tmp = [tempBankNo substringToIndex:i];
        }
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
}

- (RACSignal *)searchLocalBankInformationWithNumber:(NSString *)number {
	return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSString *tempBankNo = [number stringByReplacingOccurrencesOfString:@" " withString:@""];
		
		if (number.length == 0) [subscriber sendNext:RACTuplePack(nil, @"")];
		
		for (int i = 0; i < tempBankNo.length; i ++) {
			NSString *tmp = [tempBankNo substringToIndex:i];
			if ([tmp isEqualToString:self.oldBankNo]) {
                NSString *bankType = nil;
                switch (self.bankInfo.type.intValue) {
                    case 1:
                        bankType = @"借记卡";
                        break;
                    case 2:
                        bankType = @"贷记卡";
                        break;
                    case 3:
                        bankType = @"准贷记卡";
                        break;
                    case 4:
                        bankType =  @"预付费卡";
                        break;
                        
                    default:
                        break;
                }
                NSString *backNameAndType = [[self.bankInfo.name stringByAppendingString:@"  "] stringByAppendingString:bankType];
                [subscriber sendNext:RACTuplePack(
                                                  [UIImage imageNamed:[MSFGetBankIcon getIconNameWithBankCode:self.bankInfo.code]],
                                                  backNameAndType
                                                  )];
				return [RACDisposable disposableWithBlock:^{
					[self.fmdb close];
				}];
			}
		}
		if (![self.fmdb open]) {
			[subscriber sendNext:RACTuplePack(nil, @"")];
		} else {
			NSError *error;
			NSString *sqlStr = [NSString stringWithFormat:@"select * from basic_bank_bin where bank_bin='%@'", tempBankNo];
			FMResultSet *rs = [self.fmdb executeQuery:sqlStr];
			NSMutableArray *itemArray = [[NSMutableArray alloc] init];
			while ([rs next]) {
				MSFBankInfoModel *tmpBankInfo = [MTLFMDBAdapter modelOfClass:MSFBankInfoModel.class fromFMResultSet:rs error:&error];
				if (error) {
					[subscriber sendNext:RACTuplePack(nil,  @"")];
					return [RACDisposable disposableWithBlock:^{
						[self.fmdb close];
					}];
				}
				[itemArray addObject:tmpBankInfo];
			}
			if (itemArray.count == 1) {
				self.oldBankNo = tempBankNo;
				self.bankInfo = itemArray.firstObject;
                NSString *bankType = nil;
                switch (self.bankInfo.type.intValue) {
                    case 1:
                        bankType = @"借记卡";
                        break;
                    case 2:
                        bankType = @"贷记卡";
                        break;
                    case 3:
                        bankType = @"准贷记卡";
                        break;
                    case 4:
                        bankType =  @"预付费卡";
                        break;
                        
                    default:
                        break;
                }
                NSString *backNameAndType = [NSString stringWithFormat:@"%@  %@", self.bankInfo.name,bankType];
				[subscriber sendNext:RACTuplePack(
					[UIImage imageNamed:[MSFGetBankIcon getIconNameWithBankCode:self.bankInfo.code]],
					backNameAndType
				)];
			} else {
				[subscriber sendNext:RACTuplePack(nil,  @"")];
			}
		}
		
		return [RACDisposable disposableWithBlock:^{
			[self.fmdb close];
		}];
	}] replayLazily];
}

@end
