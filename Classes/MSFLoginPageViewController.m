//
// MSFPageViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoginPageViewController.h"

@implementation MSFLoginPageViewController

#pragma mark - Lifecycle

- (NSArray *)pageIdentifiers {
    return @[ @"MSFSignUpViewController", @"MSFSignInViewController"];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.delegate = self;
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
  
}

#pragma mark - UIPageViewControllerDataSource

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
  return 0;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
  return 0;
}

- (void)setUpViewController:(UIViewController<MSPageViewControllerChild> *)viewController atIndex:(NSInteger)index {
	[super setUpViewController:viewController atIndex:index];
}

@end
