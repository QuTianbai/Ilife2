//
// MSFUserViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUserViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFUser.h"
#import "MSFClient+Users.h"
#import "NSString+Matches.h"
#import "MSFAuthorizeViewModel.h"
#import "MSFBankCardListViewModel.h"

static const int kPasswordMaxLength = 16;
static const int kPasswordMinLength = 8;

@interface MSFUserViewModel ()

@property (nonatomic, strong, readwrite) RACSubject *contentUpdateSignal;
@property (nonatomic, weak) id <MSFViewModelServices> servcies;

@end

@implementation MSFUserViewModel

#pragma mark - Lifecycle

- (instancetype)initWithAuthorizeViewModel:(MSFAuthorizeViewModel *)viewModel services:(id <MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_servcies = services;
	_authorizeViewModel = viewModel;
	_usedPassword = @"";
	_updatePassword = @"";
	
	@weakify(self)
  _executeUpdatePassword = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    @strongify(self)
    if (![self.usedPassword isPassword]) {
      return [RACSignal error:[NSError errorWithDomain:MSFAuthorizeErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:@"原密码错误"}]];
    }
    if (![self.updatePassword isPassword]) {
      return [RACSignal error:[NSError errorWithDomain:MSFAuthorizeErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey:@"请输入8~16位字母和数字组合的新密码"}]];
    }
    return [self executeUpdatePasswordSignal];
  }];
	
	_bankCardListViewModel = [[MSFBankCardListViewModel alloc] initWithServices:self.servcies];
	
	NSString *status = [self.servcies.httpClient user].complateCustInfo;
	BOOL b0 = [status substringWithRange:NSMakeRange(0, 1)].integerValue == 1;
	BOOL b1 = [status substringWithRange:NSMakeRange(2, 1)].integerValue == 1;
	BOOL b2 = [status substringWithRange:NSMakeRange(1, 1)].integerValue == 1;
	
	NSInteger completion = 0;
	if (b0) {
		completion ++;
	}
	if (b1) {
		completion ++;
	}
	if (b2) {
		completion ++;
	}
	
	if (completion == 3) {
		self.percent = @"100%";
	} else {
		self.percent = [NSString stringWithFormat:@"%ld%%", (long)completion * 33];
	}
	
	return self;
}

#pragma mark - Public

- (RACSignal *)updateValidSignal {
	return [[RACSignal combineLatest:@[
			RACObserve(self, usedPassword),
			RACObserve(self, updatePassword)
		]]
		reduceEach:^id(NSString *password1, NSString *password2){
			return @(
				password1.length > kPasswordMinLength - 1 &&
				password1.length < kPasswordMaxLength + 1 &&
				password2.length > kPasswordMinLength - 1 &&
				password2.length < kPasswordMaxLength + 1 &&
				![password1 isEqualToString:password2]
			);
	}];
}

#pragma mark - Private

- (RACSignal *)executeUpdatePasswordSignal {
	return [self.servcies.httpClient updateSignInPassword:self.usedPassword password:self.updatePassword];
}

@end
