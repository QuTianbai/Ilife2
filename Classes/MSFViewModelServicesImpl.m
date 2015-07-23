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

- (MSFClient *)httpClient {
	return MSFUtils.httpClient;
}


@end
