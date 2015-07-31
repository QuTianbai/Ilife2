//
// MSFTabBarController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTabBarController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "MSFHomepageViewController.h"
#import "MSFUserViewController.h"
#import "MSFProductViewController.h"
#import "MSFLoginViewController.h"

#import "MSFTabBarViewModel.h"
#import "MSFHomepageViewModel.h"
#import "MSFUserViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFProductViewModel.h"

#import "MSFClient.h"
#import "MSFUser.h"
#import "MSFUtils.h"
#import "UIColor+Utils.h"
#import "MobClick.h"
#import "MSFUmengMacro.h"

@interface MSFTabBarController () 

@property (nonatomic, weak, readwrite) MSFTabBarViewModel *viewModel;

@end

@implementation MSFTabBarController

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFTabBarController `-dealloc`");
}

- (instancetype)initWithViewModel:(MSFTabBarViewModel *)viewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
	[self authenticatedControllers];
	
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
  self.tabBar.selectedImageTintColor = UIColor.themeColor;
	self.delegate = self;
}

#pragma mark - Private

- (void)unAuthenticatedControllers {
	MSFHomepageViewModel *homepageViewModel = [[MSFHomepageViewModel alloc] initWithServices:self.viewModel.services];
  MSFHomepageViewController *homePageViewController = [[MSFHomepageViewController alloc] initWithViewModel:homepageViewModel];
	UINavigationController *homepage = [[UINavigationController alloc] initWithRootViewController:homePageViewController];
  homepage.tabBarItem = [self itemWithNormal:@"tabbar-home-normal.png" selected:@"tabbar-home-selected.png"];
	homePageViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:nil action:nil];
	homePageViewController.navigationItem.leftBarButtonItem.rac_command = self.viewModel.signInCommand;
	homePageViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:nil action:nil];
	
	MSFProductViewController *productViewController = [[MSFProductViewController alloc] initWithViewModel:nil];
  UINavigationController *productpage = [[UINavigationController alloc] initWithRootViewController:productViewController];
  productpage.tabBarItem = [self itemWithNormal:@"tabbar-apply-normal.png" selected:@"tabbar-apply-selected.png"];
	
  MSFUserViewController *userViewController = [[MSFUserViewController alloc] initWithViewModel:nil];
  UINavigationController *userpage = [[UINavigationController alloc] initWithRootViewController:userViewController];
  userpage.tabBarItem =  [self itemWithNormal:@"tabbar-account-normal.png" selected:@"tabbar-account-selected.png"];
	
	self.viewControllers = @[homepage, productpage, userpage];
	self.selectedIndex = 0;
}

- (void)authenticatedControllers {
	self.viewModel.formsViewModel.active = YES;
	MSFHomepageViewModel *homepageViewModel = [[MSFHomepageViewModel alloc] initWithServices:self.viewModel.services];
	MSFHomepageViewController *homePageViewController = [[MSFHomepageViewController alloc] initWithViewModel:homepageViewModel];
	UINavigationController *homepage = [[UINavigationController alloc] initWithRootViewController:homePageViewController];
	homepage.tabBarItem = [self itemWithNormal:@"tabbar-home-normal.png" selected:@"tabbar-home-selected.png"];

	MSFProductViewModel *productViewModel = [[MSFProductViewModel alloc] initWithFormsViewModel:self.viewModel.formsViewModel];
	MSFProductViewController *productViewController = [[MSFProductViewController alloc] initWithViewModel:productViewModel];
	UINavigationController *productpage = [[UINavigationController alloc] initWithRootViewController:productViewController];
	productpage.tabBarItem = [self itemWithNormal:@"tabbar-apply-normal.png" selected:@"tabbar-apply-selected.png"];
	
	MSFUserViewModel *userViewModel = [[MSFUserViewModel alloc] initWithAuthorizeViewModel:self.viewModel.authorizeViewModel services:self.viewModel.services];
	MSFUserViewController *userViewController = [[MSFUserViewController alloc] initWithViewModel:userViewModel];
	UINavigationController *userpage = [[UINavigationController alloc] initWithRootViewController:userViewController];
	userpage.tabBarItem =  [self itemWithNormal:@"tabbar-account-normal.png" selected:@"tabbar-account-selected.png"];
	
	self.viewControllers = @[homepage, productpage, userpage];
}

- (UITabBarItem *)itemWithNormal:(NSString *)normalName selected:(NSString *)selectedName {
	UIImage *normal = [UIImage imageNamed:normalName];
	UIImage *selected = [UIImage imageNamed:selectedName];
	UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:nil image:normal selectedImage:selected];
	item.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
	
	return item;
}

#pragma mark - UITabBarControllerDelegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	NSString *tabName = @"";
	NSString *selectedIndex = [@(tabBarController.selectedIndex) stringValue];
	switch (tabBarController.selectedIndex) {
		case 0:tabName = @"马上贷";break;
		case 1:tabName = @"申请贷款";break;
		case 2:tabName = @"我的账户";break;
	}
	[MobClick event:MSF_Umeng_Statistics_TaskId_Tabs attributes:@{@"tabName":tabName, @"tabIndex":selectedIndex}];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
  if (!self.viewModel.isAuthenticated) {
		[self.viewModel.signInCommand execute:nil];
		return NO;
  } else if (!self.viewModel.isUserAuthenticated) {
    [self.viewModel.verifyCommand execute:nil];
		return NO;
  }
  if ([tabBarController.viewControllers indexOfObject:viewController] == 1) {
    UINavigationController *navigationController = (UINavigationController *)viewController;
    MSFProductViewController *productViewcontroller = navigationController.viewControllers.firstObject;
    [productViewcontroller setEmptyMoney];
		self.viewModel.formsViewModel.active = YES;
    if (self.viewModel.formsViewModel.pending) {
			[[[UIAlertView alloc] initWithTitle:@"提示"
																	message:@"您的提交的申请已经在审核中，请耐心等待!"
																 delegate:nil
												cancelButtonTitle:@"确认"
												otherButtonTitles:nil] show];
      return NO;
    }
  } else {
    self.viewModel.formsViewModel.active = NO;
  }
	
  return YES;
}

@end
