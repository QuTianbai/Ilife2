//
// MSFTabBarController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFTabBarController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "MSFUserViewController.h"

#import "MSFTabBarViewModel.h"
#import "MSFUserViewModel.h"

#import "MSFClient.h"
#import "MSFUser.h"
#import "UIColor+Utils.h"
#import "MobClick.h"
#import "MSFUmengMacro.h"

#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"

#import "MSFCirculateCashViewModel.h"

#import "MSFApplyCashViewModel.h"
#import "MSFAmortize.h"

#import "MSFCreditViewController.h"
#import "MSFWalletViewController.h"
#import "MSFCommodityViewController.h"
#import "MSFWalletViewModel.h"
#import "MSFCommodityViewModel.h"
#import "MSFCreditViewModel.h"

@interface MSFTabBarController () 

@property (nonatomic, weak, readwrite) MSFTabBarViewModel *viewModel;

@end

@implementation MSFTabBarController

#pragma mark - NSObject

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

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
  self.tabBar.selectedImageTintColor = UIColor.themeColor;
	self.delegate = self;
	self.tabBar.translucent = NO;
}

#pragma mark - Private

- (void)authenticatedControllers {
	MSFCreditViewModel *homepageViewModel = [[MSFCreditViewModel alloc] initWithServices:self.viewModel.services];
	MSFCreditViewController *homePageViewController = [[MSFCreditViewController alloc] initWithViewModel:homepageViewModel];
	homePageViewController.title = @"马上贷";
	UINavigationController *homepage = [[UINavigationController alloc] initWithRootViewController:homePageViewController];
	homepage.tabBarItem = [self itemWithNormal:@"马上贷" nomalImage:@"tab-msd-normal.png" selected:@"tab-msd-highlighted.png"];

	MSFWalletViewModel *walletViewModel = [[MSFWalletViewModel alloc] initWithServices:self.viewModel.services];
	MSFWalletViewController *walletViewController = [[MSFWalletViewController alloc] initWithViewModel:walletViewModel];
	walletViewController.title = @"信用钱包";
	UINavigationController *wallet = [[UINavigationController alloc] initWithRootViewController:walletViewController];
	wallet.tabBarItem = [self itemWithNormal:@"信用钱包" nomalImage:@"tab-wallet-normal.png" selected:@"tab-wallet-highlighted.png"];
	
	MSFCommodityViewModel *commodityViewModel = [[MSFCommodityViewModel alloc] initWithServices:self.viewModel.services];
	MSFCommodityViewController *commodityViewController = [[MSFCommodityViewController alloc] initWithViewModel:commodityViewModel];
	commodityViewController.title = @"商品贷";
	UINavigationController *commodity = [[UINavigationController alloc] initWithRootViewController:commodityViewController];
	commodityViewController.tabBarItem = [self itemWithNormal:@"商品贷" nomalImage:@"tab-commodity-normal.png" selected:@"tab-commodity-highlighted.png"];
	
	MSFUserViewModel *userViewModel = [[MSFUserViewModel alloc] initWithServices:self.viewModel.services];
	MSFUserViewController *userViewController = [[MSFUserViewController alloc] initWithViewModel:userViewModel];
	userViewController.title = @"我的";
	UINavigationController *userpage = [[UINavigationController alloc] initWithRootViewController:userViewController];
	userpage.tabBarItem =  [self itemWithNormal:@"我的" nomalImage:@"tab-me-normal.png" selected:@"tab-me-hightlighted.png"];
	
	self.viewControllers = @[homepage, wallet, commodity, userpage];
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

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController NS_AVAILABLE_IOS(3_0) {
    NSLog(@"%@", tabBarController.tabBarItem.title);
    if ([((UINavigationController *)viewController).viewControllers.firstObject isKindOfClass:[MSFWalletViewController class]]) {
        MSFUser *user = [self.viewModel.services httpClient].user;
        if (![user.custType isEqualToString:@"1"]) {
            [SVProgressHUD showInfoWithStatus:@"您所在的区域暂未开通，目前支持城市重庆"];
            return NO;
        }
    }
    return YES;
}

@end
