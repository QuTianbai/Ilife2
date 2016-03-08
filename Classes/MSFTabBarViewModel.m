//
// MSFTabBarViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTabBarViewModel.h"
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFAuthorizeViewModel.h"
#import "MSFUser.h"
#import "MSFClient.h"

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
	_authorizeViewModel = [[MSFAuthorizeViewModel alloc] initWithServices:self.services];
	_authorizationUpdatedSignal = [[RACSubject subject] setNameWithFormat:@"MSFTabBarViewModel `authorizationUpdatedSignal`"];
	
	@weakify(self)
	[self.authorizeViewModel.executeSignIn.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[signal subscribeNext:^(id x) {
			[(RACSubject *)self.authorizationUpdatedSignal sendNext:x];
		}];
	}];
	[self.authorizeViewModel.executeSignUp.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[signal subscribeNext:^(id x) {
			[(RACSubject *)self.authorizationUpdatedSignal sendNext:x];
		}];
	}];
	[self.authorizeViewModel.executeSignOut.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[signal subscribeNext:^(id x) {
			[(RACSubject *)self.authorizationUpdatedSignal sendNext:self.services.httpClient];
		}];
	}];
	[self.authorizeViewModel.executeUpdateSignInPassword.executionSignals subscribeNext:^(RACSignal *signal){
		@strongify(self)
		[signal subscribeNext:^(id x) {
			[self.authorizeViewModel.executeSignOut execute:nil];
		}];
	}];
	[self.authorizeViewModel.executeAlterMobile.executionSignals subscribeNext:^(RACSignal *signal){
		@strongify(self)
		[signal subscribeNext:^(id x) {
			[self.authorizeViewModel.executeSignOut execute:nil];
		}];
	}];
}

@end
