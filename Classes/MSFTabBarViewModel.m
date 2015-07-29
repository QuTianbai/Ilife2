//
// MSFTabBarViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTabBarViewModel.h"
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "MSFAuthorizeViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFClozeViewModel.h"
#import "MSFUser.h"
#import "MSFClient.h"
#import "MSFClozeViewController.h"

@interface MSFTabBarViewModel ()

@property (nonatomic, strong, readwrite) RACSubject *authorizationUpdatedSignal;
@property (nonatomic, weak, readwrite) id <MSFViewModelServices> services;

@end

@implementation MSFTabBarViewModel

#pragma mark - Lifecycle

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
	if (!(self = [self init])) {
    return nil;
	}
	_services = services;
	[self initialize];
	
	return self;
}

#pragma mark - Private

- (void)initialize {
	_formsViewModel = [[MSFFormsViewModel alloc] initWithServices:self.services];
	_authorizeViewModel = [[MSFAuthorizeViewModel alloc] initWithServices:self.services];
	_authorizationUpdatedSignal = [[RACSubject subject] setNameWithFormat:@"MSFTabBarViewModel updatedContentSignal"];
	
	@weakify(self)
	_signInCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self signInSignal];
	}];
	_signUpCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self signUpSignal];
	}];
	_verifyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self verifySignal];
	}];
	
	[self.authorizeViewModel.executeSignIn.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[signal subscribeNext:^(id x) {
			[(RACSubject *)self.authorizationUpdatedSignal sendNext:x];
		}];
	}];
	[self.authorizeViewModel.executeSignOut.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[signal subscribeNext:^(id x) {
			[(RACSubject *)self.authorizationUpdatedSignal sendNext:x];
		}];
	}];
	[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"MSFClozeViewModelDidUpdateNotification" object:nil]
		takeUntil:self.rac_willDeallocSignal]
		subscribeNext:^(NSNotification *notification) {
			@strongify(self)
			MSFClient *client = notification.object;
			[(RACSubject *)self.authorizationUpdatedSignal sendNext:client];
	}];
}

#pragma mark - Custom Accessors

- (RACSignal *)signInSignal {
  @weakify(self)
  RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    @strongify(self)
		self.authorizeViewModel.loginType = MSFLoginSignIn;
		[self.services presentViewModel:self.authorizeViewModel];
		[subscriber sendCompleted];
		return nil;
  }];
  
  return [[signal replay] setNameWithFormat:@"%@ `-signIn`", self.class];
}

- (RACSignal *)signUpSignal {
	@weakify(self)
  RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    @strongify(self)
		self.authorizeViewModel.loginType = MSFLoginSignUp;
		[self.services presentViewModel:self.authorizeViewModel];
		return nil;
  }];
  
  return [[signal replay] setNameWithFormat:@"%@ `-signUp`", self.class];
}

- (RACSignal *)verifySignal {
  return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFClozeViewModel *viewModel = [[MSFClozeViewModel alloc] initWithServices:self.services];
		[self.services presentViewModel:viewModel];
    [subscriber sendCompleted];
		return nil;
  }] replay] setNameWithFormat:@"%@ `-verify`", self.class];
}

#pragma mark - Custom Accessors

- (BOOL)isAuthenticated {
	return [self.services httpClient].isAuthenticated;
}

- (BOOL)isUserAuthenticated {
	return [self.services httpClient].user.isAuthenticated;
}

@end
