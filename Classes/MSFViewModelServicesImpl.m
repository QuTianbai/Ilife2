//
// MSFViewModelServicesImpl.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFViewModelServicesImpl.h"
#import "MSFClient.h"
#import "MSFUtils.h"

#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"

#import "MSFAuthorizeViewModel.h"
#import "MSFLoginViewController.h"

#import "MSFClozeViewModel.h"
#import "MSFClozeViewController.h"

@interface MSFViewModelServicesImpl ()

@property (nonatomic, weak) UITabBarController *tabBarController;

@end

@implementation MSFViewModelServicesImpl

- (instancetype)initWithTabBarController:(UITabBarController *)tabBarController {
  self = [super init];
  if (!self) {
    return nil;
  }
	_tabBarController = tabBarController;
  
  return self;
}

#pragma mark - MSFViewModelServices

- (void)pushViewModel:(id)viewModel {
	id viewController;
  
  if ([viewModel isKindOfClass:MSFSelectionViewModel.class]) {
    viewController = [[MSFSelectionViewController alloc] initWithViewModel:viewModel];
  } else {
    NSLog(@"an unknown ViewModel was pushed!");
  }
  
  [(UINavigationController *)self.tabBarController.selectedViewController pushViewController:viewController animated:YES];
}

- (void)presentViewModel:(id)viewModel {
	id viewController;
  
	if ([viewModel isKindOfClass:MSFAuthorizeViewModel.class]) {
		MSFLoginViewController *loginViewController = [[MSFLoginViewController alloc] initWithViewModel:viewModel];
		viewController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
	} else if ([viewModel isKindOfClass:MSFClozeViewModel.class]) {
    MSFClozeViewController *clozeViewController = [[MSFClozeViewController alloc] initWithViewModel:viewModel];
		viewController = [[UINavigationController alloc] initWithRootViewController:clozeViewController];
	} else {
    NSLog(@"an unknown ViewModel was present!");
  }
  
  [self.tabBarController.selectedViewController presentViewController:viewController animated:YES completion:nil];
}

- (MSFClient *)httpClient {
	return MSFUtils.httpClient;
}

- (MSFServer *)server {
	return MSFUtils.server;
}

@end
