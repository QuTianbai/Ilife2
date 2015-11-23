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

#import "MSFCirculateCashTableViewController.h"
#import "MSFCirculateCashViewModel.h"

#import "MSFApplyCashVIewModel.h"
#import "MSFMarkets.h"
#import "MSFCashHomePageViewController.h"
#import "MSFProductListModel.h"

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
	homePageViewController.title = @"首页";
	UINavigationController *homepage = [[UINavigationController alloc] initWithRootViewController:homePageViewController];
	homepage.tabBarItem = [self itemWithNormal:@"首页" nomalImage:@"tabbar-home-normal.png" selected:@"tabbar-home-selected.png"];

	MSFApplyCashVIewModel *cashViewModel = [[MSFApplyCashVIewModel alloc] initWithViewModel:self.viewModel.formsViewModel];
	MSFCirculateCashViewModel *circulateViewModel = [[MSFCirculateCashViewModel alloc] initWithServices:self.viewModel.services];
	self.circulateViewModel = circulateViewModel;
	MSFCashHomePageViewController *cashViewController = [[MSFCashHomePageViewController alloc] initWithViewModel:cashViewModel AndCirculateViewModel:self.circulateViewModel];
	cashViewController.title = @"马上";
	UINavigationController *productpage = [[UINavigationController alloc] initWithRootViewController:cashViewController];
	
	if ([[self.viewModel.services httpClient].user.type isEqualToString:@"4101"]) {
		//MSFCirculateCashViewModel *viewModel = [[MSFCirculateCashViewModel alloc] initWithServices:self.viewModel.services];
		//self.circulateViewModel = viewModel;
		MSFCirculateCashTableViewController *circulateViewController = [[MSFCirculateCashTableViewController alloc] initWithViewModel:self.circulateViewModel];
		circulateViewController.title = @"马上";
		productpage = [[UINavigationController alloc] initWithRootViewController:circulateViewController];
	}
	productpage.tabBarItem = [self itemWithNormal:@"马上" nomalImage:@"tabbar-apply-normal.png" selected:@"tabbar-apply-selected.png"];
	
	MSFUserViewModel *userViewModel = [[MSFUserViewModel alloc] initWithAuthorizeViewModel:self.viewModel.authorizeViewModel services:self.viewModel.services];
	MSFUserViewController *userViewController = [[MSFUserViewController alloc] initWithViewModel:userViewModel];
	userViewController.title = @"我的";
	UINavigationController *userpage = [[UINavigationController alloc] initWithRootViewController:userViewController];
	userpage.tabBarItem =  [self itemWithNormal:@"我的" nomalImage:@"tabbar-account-normal.png" selected:@"tabbar-account-selected.png"];
	
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
		case 0:tabName = @"马上金融";break;
		case 1:tabName = @"申请贷款";break;
		case 2:tabName = @"我的账户";break;
	}
	[MobClick event:MSF_Umeng_Statistics_TaskId_Tabs attributes:@{@"tabName":tabName, @"tabIndex":selectedIndex}];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
  if ([tabBarController.viewControllers indexOfObject:viewController] == 1) {
		[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
		[[[self.viewModel.formsViewModel fetchProductListignal] collect]
		subscribeNext:^(NSArray *dataArray) {
			[SVProgressHUD dismiss];
			if ([dataArray containsObject:@"1101"] && [dataArray containsObject:@"4101"]) {
				
    
			} else if ([dataArray containsObject:@"1101"] && [dataArray containsObject:@"4102"]) {
				
				
			} else if ([dataArray containsObject:@"1101"] && ![dataArray containsObject:@"4101"] && ![dataArray containsObject:@"4102"]) {
				
				
			}
			int i = 0;
			int j = 0;
			for (MSFProductListModel *model in dataArray) {
				if ([model.productId isEqualToString:@"1101"]) {
					self.viewModel.formsViewModel.active = NO;
					self.viewModel.formsViewModel.active = YES;
					i++;
					j++;
				}
				if ([model.productId isEqualToString:@"4101"]) {
					self.circulateViewModel.active = NO;
					self.circulateViewModel.active = YES;
					i++;
				}
				if ([model.productId isEqualToString:@"4102"]) {
					self.circulateViewModel.active = NO;
					self.circulateViewModel.active = YES;
					j++;
				}
			}
			if (i == 1 && j == 1) {
				//马上贷
				self.viewModel.formsViewModel.active = NO;
				self.viewModel.formsViewModel.active = YES;
				self.circulateViewModel.status = APPLYCASH;
			} else if (i == 2 && j ==1) {
				//马上贷和循环贷
				self.viewModel.formsViewModel.active = NO;
				self.viewModel.formsViewModel.active = YES;
				self.circulateViewModel.active = NO;
				self.circulateViewModel.active = YES;
				self.circulateViewModel.status = APPLYANGCIRCULATECASH;
			} else if (i == 1 && j == 2) {
				//马上贷和社保贷
				self.viewModel.formsViewModel.active = NO;
				self.viewModel.formsViewModel.active = YES;
				self.circulateViewModel.active = NO;
				self.circulateViewModel.active = YES;
				self.circulateViewModel.status = ALLPYANDSOCIALCASH;
			}
			
			
			NSLog(@"fda");
		}];
		if ([[self.viewModel.services httpClient].user.type isEqualToString:@"4101"]) {
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
