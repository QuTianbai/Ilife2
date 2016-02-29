//
// MSFTabBarController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTabBarController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
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
#import "UIColor+Utils.h"
#import "MobClick.h"
#import "MSFUmengMacro.h"

#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"

#import "MSFCirculateCashViewModel.h"

#import "MSFApplyCashViewModel.h"
#import "MSFMarkets.h"
#import "MSFCashHomePageViewController.h"
#import "MSFCashHomePageViewModel.h"

#import "MSFCreditViewController.h"
#import "MSFWalletViewController.h"
#import "MSFCommodityViewController.h"

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
	self.tabBar.translucent = NO;
}

#pragma mark - Private

- (void)authenticatedControllers {
	self.viewModel.formsViewModel.active = YES;
	//TODO:
	MSFHomepageViewModel *homepageViewModel = [[MSFHomepageViewModel alloc] initWithModel:self.viewModel.formsViewModel services:self.viewModel.services];
	
	MSFCreditViewController *homePageViewController = [[MSFCreditViewController alloc] initWithViewModel:homepageViewModel];
	homePageViewController.title = @"马上贷";
	UINavigationController *homepage = [[UINavigationController alloc] initWithRootViewController:homePageViewController];
	homepage.tabBarItem = [self itemWithNormal:@"马上贷" nomalImage:@"tabbar-home-normal.png" selected:@"tabbar-home-selected.png"];

	MSFCirculateCashViewModel *circulateViewModel = [[MSFCirculateCashViewModel alloc] initWithServices:self.viewModel.services];
	self.circulateViewModel = circulateViewModel;
	
	//TODO:
	MSFCashHomePageViewModel *cashHomePageViewModel = [[MSFCashHomePageViewModel alloc] initWithFormViewModel:self.viewModel.formsViewModel services:self.viewModel.services];
	
	MSFWalletViewController *cashViewController = [[MSFWalletViewController alloc] initWithViewModel:cashHomePageViewModel];
	cashViewController.title = @"信用钱包";
	UINavigationController *productpage = [[UINavigationController alloc] initWithRootViewController:cashViewController];
	productpage.tabBarItem = [self itemWithNormal:@"信用钱包" nomalImage:@"tabbar-apply-normal.png" selected:@"tabbar-apply-selected.png"];
	
	//TODO:
	MSFCommodityViewController *commodityViewController = [[MSFCommodityViewController alloc] initWithViewModel:circulateViewModel];
	commodityViewController.title = @"商品贷";
	UINavigationController *commodity = [[UINavigationController alloc] initWithRootViewController:commodityViewController];
	commodityViewController.tabBarItem = [self itemWithNormal:@"商品贷" nomalImage:@"tabbar-account-normal.png" selected:@"tabbar-account-selected.png"];
	
	//TODO:
	MSFUserViewModel *userViewModel = [[MSFUserViewModel alloc] initWithAuthorizeViewModel:self.viewModel.authorizeViewModel services:self.viewModel.services];
	
	MSFUserViewController *userViewController = [[MSFUserViewController alloc] initWithViewModel:userViewModel];
	userViewController.title = @"我的";
	UINavigationController *userpage = [[UINavigationController alloc] initWithRootViewController:userViewController];
	userpage.tabBarItem =  [self itemWithNormal:@"我的" nomalImage:@"tabbar-account-normal.png" selected:@"tabbar-account-selected.png"];
	
	self.viewControllers = @[homepage, productpage, commodity, userpage];
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
		case 0:tabName = @"马上金融";break;
		case 1:tabName = @"申请贷款";break;
		case 2:tabName = @"我的账户";break;
	}
	[MobClick event:MSF_Umeng_Statistics_TaskId_Tabs attributes:@{@"tabName":tabName, @"tabIndex":selectedIndex}];
}

@end
