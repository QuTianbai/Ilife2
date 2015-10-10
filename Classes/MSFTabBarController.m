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
#import "MSFMarkets.h"
#import "MSFCashHomePageViewController.h"

@interface MSFTabBarController () 

@property (nonatomic, weak, readwrite) MSFTabBarViewModel *viewModel;

@property (nonatomic, strong) MSFCirculateCashViewModel *circulateViewModel;

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

- (void)authenticatedControllers {
	self.viewModel.formsViewModel.active = YES;
	MSFHomepageViewModel *homepageViewModel = [[MSFHomepageViewModel alloc] initWithModel:self.viewModel.formsViewModel services:self.viewModel.services];
	MSFHomepageViewController *homePageViewController = [[MSFHomepageViewController alloc] initWithViewModel:homepageViewModel];
	UINavigationController *homepage = [[UINavigationController alloc] initWithRootViewController:homePageViewController];
	homepage.tabBarItem = [self itemWithNormal:@"马上贷" nomalImage:@"tabbar-home-normal.png" selected:@"tabbar-home-selected.png"];

	MSFApplyCashVIewModel *cashViewModel = [[MSFApplyCashVIewModel alloc] initWithViewModel:self.viewModel.formsViewModel];
	MSFCashHomePageViewController *cashViewController = [[MSFCashHomePageViewController alloc] initWithViewModel:cashViewModel];
	UINavigationController *productpage = [[UINavigationController alloc] initWithRootViewController:cashViewController];
	
	if ([MSFUtils.isCircuteCash isEqualToString:@"4101"]) {
		MSFCirculateCashViewModel *viewModel = [[MSFCirculateCashViewModel alloc] initWithServices:self.viewModel.services];
		self.circulateViewModel = viewModel;
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
  if ([tabBarController.viewControllers indexOfObject:viewController] == 1) {
		if ([MSFUtils.isCircuteCash isEqualToString:@"4101"]) {
			self.circulateViewModel.active = NO;
			self.circulateViewModel.active = YES;
		} else {
			self.viewModel.formsViewModel.active = NO;
			self.viewModel.formsViewModel.active = YES;
		}
  }

  return YES;
}

@end
