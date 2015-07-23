//
// MSFTabBarViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTabBarViewModel.h"
#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "MSFUtils.h"
#import "MSFSignInViewController.h"
#import "MSFClozeViewController.h"
#import "MSFAuthorizeViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFLoginViewController.h"
#import "MSFLoginSwapController.h"

@interface MSFTabBarViewModel ()

@property (nonatomic, strong, readwrite) RACSubject *authorizationUpdatedSignal;
@property (nonatomic, weak) id <MSFViewModelServices> services;

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

- (instancetype)init {
  self = [super init];
  if (!self) {
    return nil;
  }
	[self initialize];

  return self;
}

#pragma mark - Private

- (void)initialize {
	_formsViewModel = [[MSFFormsViewModel alloc] init];
	_authorizeViewModel = [[MSFAuthorizeViewModel alloc] init];
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
}

#pragma mark - Custom Accessors

- (MSFClient *)client {
	return MSFUtils.httpClient;
}

- (RACSignal *)signInSignal {
  @weakify(self)
  RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    @strongify(self)
    MSFLoginViewController *loginViewController = [[MSFLoginViewController alloc] initWithViewModel:self.authorizeViewModel loginType:MSFLoginSignIn];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
		navigationController.navigationBarHidden = YES;
    [self.class.topMostController presentViewController:navigationController animated:YES completion:nil];
		[subscriber sendCompleted];
		
    return [RACDisposable disposableWithBlock:^{
      [loginViewController.navigationItem.leftBarButtonItem.rac_command executionSignals];
    }];
  }];
  
  return [[signal replay] setNameWithFormat:@"%@ -`signIn`",self.class];
}

- (RACSignal *)signUpSignal {
	@weakify(self)
  RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    @strongify(self)
		MSFLoginViewController *loginViewController = [[MSFLoginViewController alloc] initWithViewModel:self.authorizeViewModel loginType:MSFLoginSignUp];
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
		navigationController.navigationBarHidden = YES;
    [self.class.topMostController presentViewController:navigationController animated:YES completion:nil];
		[subscriber sendCompleted];
		
    return [RACDisposable disposableWithBlock:^{
    }];
  }];
  
  return [[signal replay] setNameWithFormat:@"%@ -`signIn`",self.class];
}

- (RACSignal *)verifySignal {
  return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
    MSFClozeViewController *clozeViewController =
    [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(MSFClozeViewController.class)];
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:clozeViewController];
    [self.class.topMostController presentViewController:navigationController animated:YES completion:nil];
    [subscriber sendCompleted];
    
    return [RACDisposable disposableWithBlock:^{
      
    }];
  }] replay];
}

#pragma mark - Privat

+ (UIViewController *)topMostController {
  UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
  while (topController.presentedViewController) {
    topController = topController.presentedViewController;
  }
  return topController;
}

@end
