//
// MSFUserViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUserViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFUser.h"
#import "MSFClient+Users.h"
#import "NSString+Matches.h"
#import "MSFAuthorizeViewModel.h"
#import "AppDelegate.h"

@interface MSFUserViewModel ()

@property (nonatomic, strong, readwrite) RACSubject *contentUpdateSignal;
@property (nonatomic, strong, readwrite) MSFUser *model;
@property (nonatomic, assign, readwrite) BOOL isAuthenticated;

@end

@implementation MSFUserViewModel

#pragma mark - Lifecycle

- (instancetype)initWithServices:(id <MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_authorizeViewModel = [(AppDelegate *)[UIApplication sharedApplication].delegate authorizeVewModel];
	
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[self.services.httpClient fetchUserInfo] subscribeNext:^(MSFUser *model) {
			if (model.personal) {
				[self.services.httpClient.user mergeValueForKey:@keypath(MSFUser.new, personal) fromModel:model];
			}
			if (model.professional) {
				[self.services.httpClient.user mergeValueForKey:@keypath(MSFUser.new, professional) fromModel:model];
			}
			if (model.profiles) {
				[self.services.httpClient.user mergeValueForKey:@keypath(MSFUser.new, profiles) fromModel:model];
			}
			if (model.contacts) {
				[self.services.httpClient.user mergeValueForKey:@keypath(MSFUser.new, contacts) fromModel:model];
			}
			self.model = self.services.httpClient.user;
			self.isAuthenticated = self.model.isAuthenticated;
		}];
	}];
	
	return self;
}

- (instancetype)initWithAuthorizeViewModel:(MSFAuthorizeViewModel *)viewModel services:(id <MSFViewModelServices>)services {
	self = [self initWithServices:services];
	if (!self) {
		return nil;
	}
	
	return self;
}

@end
