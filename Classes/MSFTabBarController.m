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
#import "MSFAuthorizationView.h"

#import "MSFTabBarViewModel.h"
#import "MSFHomepageViewModel.h"
#import "MSFUserViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFProductViewModel.h"

#import "MSFClient.h"
#import "MSFUser.h"
#import "MSFUtils.h"
#import "UIColor+Utils.h"

@interface MSFTabBarController () <UIAlertViewDelegate>

@end

@implementation MSFTabBarController

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(MSFTabBarViewModel *)tabBarViewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	
	_viewModel = tabBarViewModel;
	[self unAuthenticatedControllers];
	@weakify(self)
	MSFAuthorizationView *view = [[MSFAuthorizationView alloc] initWithFrame:UIScreen.mainScreen.bounds];
	[self.view addSubview:view];
	[view bindViewModel:self.viewModel];
	
	[self.viewModel.authorizationUpdatedSignal subscribeNext:^(MSFClient *client) {
		@strongify(self)
		if ([self.view.subviews containsObject:view] && client.isAuthenticated) {
			[view removeFromSuperview];
		}
		self.viewModel.formsViewModel.active = NO;
		if (client.authenticated) {
			[self authenticatedControllers];
		} else {
			[self unAuthenticatedControllers];
		}
	}];
	
	[[[NSNotificationCenter defaultCenter]
	rac_addObserverForName:@"MSFClozeViewModelDidUpdateNotification" object:nil]
	subscribeNext:^(NSNotification *notification) {
		@strongify(self)
		MSFClient *client = notification.object;
		self.viewModel.formsViewModel.active = NO;
		[self authenticatedControllers];
		if ([self.view.subviews containsObject:view] && client.isAuthenticated) {
			[view removeFromSuperview];
		}
	}];
	
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
  self.tabBar.selectedImageTintColor = UIColor.themeColor;
	self.delegate = self;
	@weakify(self)
	[[[NSNotificationCenter defaultCenter]
		rac_addObserverForName:@"application-success" object:nil]
		subscribeNext:^(id x) {
			@strongify(self)
			self.viewModel.formsViewModel.active = NO;
			[self authenticatedControllers];
		}];
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已在另一设备上登录，如非本人操作请立即修改密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	alertView.delegate = self;
	[[[NSNotificationCenter defaultCenter]
		rac_addObserverForName:MSFAuthorizationDidErrorNotification object:nil]
		subscribeNext:^(NSNotification *notification) {
			@strongify(self)
			[self unAuthenticatedControllers];
			NSError *error = notification.object;
			if ([error.userInfo[NSLocalizedFailureReasonErrorKey] isEqualToString:@"已在另一设备上登录，如非本人操作请立即修改密码"]) {
				[MSFUtils setHttpClient:nil];
				if (!alertView.isVisible) {
					[alertView show];
				}
			}
		}];
	UIAlertView *alertView2 = [[UIAlertView alloc] initWithTitle:@"无法连接到服务器"
   message:nil delegate:nil cancelButtonTitle:@"重新连接" otherButtonTitles:nil];
  [alertView2.rac_buttonClickedSignal subscribeNext:^(id x) {
    [MSFUtils.setupSignal subscribeNext:^(id x) {
			[self unAuthenticatedControllers];
    }];
  }];
  [[[NSNotificationCenter defaultCenter]
		rac_addObserverForName:MSFAuthorizationDidLoseConnectNotification object:nil]
		subscribeNext:^(id x) {
     if (!alertView2.isVisible) {
       [alertView2 show];
     }
   }];
 
  [[[NSNotificationCenter defaultCenter] rac_addObserverForName:MSFAuthorizationDidReGetTimeServer object:nil]
  subscribeNext:^(id x) {
    [MSFUtils.setupSignal subscribeNext:^(id x) {
     // [self unAuthenticatedControllers];
    }];
  }];
  
  
  
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[self.viewModel.signInCommand execute:nil];
	}
}

#pragma mark - Private

- (void)unAuthenticatedControllers {
	MSFHomepageViewModel *homepageViewModel = [[MSFHomepageViewModel alloc] initWithClient:self.viewModel.client];
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
	MSFHomepageViewModel *homepageViewModel = [[MSFHomepageViewModel alloc] initWithClient:self.viewModel.client];
	MSFHomepageViewController *homePageViewController = [[MSFHomepageViewController alloc] initWithViewModel:homepageViewModel];
	UINavigationController *homepage = [[UINavigationController alloc] initWithRootViewController:homePageViewController];
	homepage.tabBarItem = [self itemWithNormal:@"tabbar-home-normal.png" selected:@"tabbar-home-selected.png"];
	homePageViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:nil action:nil];
	
	MSFProductViewModel *productViewModel = [[MSFProductViewModel alloc] initWithFormsViewModel:self.viewModel.formsViewModel];
	MSFProductViewController *productViewController = [[MSFProductViewController alloc] initWithViewModel:productViewModel];
	UINavigationController *productpage = [[UINavigationController alloc] initWithRootViewController:productViewController];
	productpage.tabBarItem = [self itemWithNormal:@"tabbar-apply-normal.png" selected:@"tabbar-apply-selected.png"];
	
	MSFUserViewModel *userViewModel = [[MSFUserViewModel alloc] initWithAuthorizeViewModel:self.viewModel.authorizeViewModel];
	MSFUserViewController *userViewController = [[MSFUserViewController alloc] initWithViewModel:userViewModel];
	UINavigationController *userpage = [[UINavigationController alloc] initWithRootViewController:userViewController];
	userpage.tabBarItem =  [self itemWithNormal:@"tabbar-account-normal.png" selected:@"tabbar-account-selected.png"];
	
	self.viewControllers = @[homepage, productpage, userpage];
	/*
	@weakify(self)
	[self.viewModel.formsViewModel.updatedContentSignal subscribeNext:^(id x) {
		@strongify(self)
    //防止在加载完贷款信息和贷款期数产品后自动跳回第一个tabBarViewContrller
		//self.selectedIndex = 0;
	}];
	*/
}

- (UITabBarItem *)itemWithNormal:(NSString *)normalName selected:(NSString *)selectedName {
	UIImage *normal = [UIImage imageNamed:normalName];
	UIImage *selected = [UIImage imageNamed:selectedName];
	UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:nil image:normal selectedImage:selected];
	item.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
	
	return item;
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
  if (!self.viewModel.client.isAuthenticated) {
		[self.viewModel.signInCommand execute:nil];
		return NO;
  } else if (![self.viewModel.client.user isAuthenticated]) {
    [self.viewModel.verifyCommand execute:nil];
		return NO;
  }
  if ([tabBarController.viewControllers indexOfObject:viewController] == 1) {
    if (!self.viewModel.formsViewModel.isHaveProduct) {
      self.viewModel.formsViewModel.active = YES;
    }
    if (self.viewModel.formsViewModel.pending) {
      UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的提交的申请已经在审核中，请耐心等待!" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
      [alertView show];
      return NO;
    }
  } else {
    self.viewModel.formsViewModel.active = NO;
  }
	
  return YES;
}

@end
