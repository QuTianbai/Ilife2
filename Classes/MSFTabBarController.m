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

#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"

#import "MSFCirculateCashTableViewController.h"
#import "MSFCirculateCashViewModel.h"

#import "MSFApplyCashVIewModel.h"

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
  homepage.tabBarItem = [self itemWithNormal:@"马上贷" nomalImage:@"tabbar-home-normal.png" selected:@"tabbar-home-selected.png"];
	homePageViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:nil action:nil];
	homePageViewController.navigationItem.leftBarButtonItem.rac_command = self.viewModel.signInCommand;
	homePageViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:nil action:nil];
	
	MSFProductViewController *productViewController = [[MSFProductViewController alloc] initWithViewModel:nil];
  UINavigationController *productpage = [[UINavigationController alloc] initWithRootViewController:productViewController];
	
	if ([MSFUtils.isCircuteCash isEqualToString:@"1"]) {
		MSFCirculateCashViewModel *viewModel = [[MSFCirculateCashViewModel alloc] initWithServices:self.viewModel.services];
		MSFCirculateCashTableViewController *circulateViewController = [[MSFCirculateCashTableViewController alloc] initWithViewModel:viewModel];
		productpage = [[UINavigationController alloc] initWithRootViewController:circulateViewController];
		
	}
	
  productpage.tabBarItem = [self itemWithNormal:@"申请贷款" nomalImage:@"tabbar-apply-normal.png" selected:@"tabbar-apply-selected.png"];
	
	
  MSFUserViewController *userViewController = [[MSFUserViewController alloc] initWithViewModel:nil];
  UINavigationController *userpage = [[UINavigationController alloc] initWithRootViewController:userViewController];
	
	
  userpage.tabBarItem =  [self itemWithNormal:@"我的账户" nomalImage:@"tabbar-account-normal.png" selected:@"tabbar-account-selected.png"];
	
	self.viewControllers = @[homepage, productpage, userpage];
	self.selectedIndex = 0;
}

- (void)authenticatedControllers {
	self.viewModel.formsViewModel.active = YES;
	MSFHomepageViewModel *homepageViewModel = [[MSFHomepageViewModel alloc] initWithServices:self.viewModel.services];
	MSFHomepageViewController *homePageViewController = [[MSFHomepageViewController alloc] initWithViewModel:homepageViewModel];
	UINavigationController *homepage = [[UINavigationController alloc] initWithRootViewController:homePageViewController];
	homepage.tabBarItem = [self itemWithNormal:@"马上贷" nomalImage:@"tabbar-home-normal.png" selected:@"tabbar-home-selected.png"];

	//MSFProductViewModel *productViewModel = [[MSFProductViewModel alloc] initWithFormsViewModel:self.viewModel.formsViewModel];
	
	MSFApplyCashVIewModel *productViewModel = [[MSFApplyCashVIewModel alloc] initWithViewModel:self.viewModel.formsViewModel];
	
	MSFProductViewController *productViewController = [[MSFProductViewController alloc] initWithViewModel:productViewModel];
	UINavigationController *productpage = [[UINavigationController alloc] initWithRootViewController:productViewController];
	
	if ([MSFUtils.isCircuteCash isEqualToString:@"1"]) {
		MSFCirculateCashViewModel *viewModel = [[MSFCirculateCashViewModel alloc] initWithServices:self.viewModel.services];
		MSFCirculateCashTableViewController *circulateViewController = [[MSFCirculateCashTableViewController alloc] initWithViewModel:viewModel];
		productpage = [[UINavigationController alloc] initWithRootViewController:circulateViewController];
		
	}
	
	productpage.tabBarItem = [self itemWithNormal:@"申请贷款" nomalImage:@"tabbar-apply-normal.png" selected:@"tabbar-apply-selected.png"];
	
	MSFUserViewModel *userViewModel = [[MSFUserViewModel alloc] initWithAuthorizeViewModel:self.viewModel.authorizeViewModel services:self.viewModel.services];
	MSFUserViewController *userViewController = [[MSFUserViewController alloc] initWithViewModel:userViewModel];
	UINavigationController *userpage = [[UINavigationController alloc] initWithRootViewController:userViewController];
	userpage.tabBarItem =  [self itemWithNormal:@"我的账户" nomalImage:@"tabbar-account-normal.png" selected:@"tabbar-account-selected.png"];
	
	self.viewControllers = @[homepage, productpage, userpage];
}

- (UITabBarItem *)itemWithNormal:(NSString *)title nomalImage:(NSString *)normalName selected:(NSString *)selectedName {
	UIImage *normal = [[UIImage imageNamed:normalName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UIImage *selected = [[UIImage imageNamed:selectedName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
	UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:normal selectedImage:selected];
	NSDictionary *titleAttributs = @{NSForegroundColorAttributeName:[MSFCommandView getColorWithString:POINTCOLOR]};
	[item setTitleTextAttributes:titleAttributs forState:UIControlStateSelected];
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
		self.viewModel.formsViewModel.active = YES;
  }
	
  return YES;
}

@end
