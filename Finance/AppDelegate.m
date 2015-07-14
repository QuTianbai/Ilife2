//
//  AppDelegate.m
//  Cash
//
//  Created by gitmac on 5/14/15.
//  Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "AppDelegate.h"
#import <libextobjc/extobjc.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFUtils.h"
#import "MSFUser.h"
#import "MSFReleaseNote.h"
#import "MSFClient+ReleaseNote.h"
#import "UIColor+Utils.h"
#import "RCLocationManager.h"

#import "MSFHomepageViewController.h"
#import "MSFUserViewController.h"

#import "MSFSettingsViewController.h"
#import "MSFLoginViewController.h"
#import "MSFClozeViewController.h"
#import "MSFGuideViewController.h"
#import "MSFProductViewController.h"
#import "MSFFormsViewModel.h"
#import "MSFClient+Users.h"
#import "MSFResponse.h"
#import "MSFProductViewModel.h"

#import "MSFPlaceholderCollectionViewCell.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface AppDelegate () <UITabBarControllerDelegate>

@property (nonatomic, strong) MSFFormsViewModel *formsViewModel;

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [Fabric with:@[CrashlyticsKit]];
  
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  self.window.backgroundColor = UIColor.whiteColor;
  [self.window makeKeyAndVisible];
  
  UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [indicatorView startAnimating];
  [self.window addSubview:indicatorView];
  [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self.window);
  }];
  
  [[MSFUtils.setupSignal catch:^RACSignal *(NSError *error) {
    [indicatorView removeFromSuperview];
#if DEBUG
    [self setup];
    [MSFGuideViewController.guide show];
    
    return [RACSignal empty];
#endif
    
    return MSFUtils.setupSignal;
  }] subscribeNext:^(id x) {
    [indicatorView removeFromSuperview];
    [self setup];
    [MSFGuideViewController.guide show];
  }];
  
  [[MSFUtils.httpClient fetchReleaseNote] subscribeNext:^(MSFReleaseNote *releasenote) {
    //TODO: 更新提醒
  }];
  
  [[RCLocationManager sharedManager]
   requestUserLocationWhenInUseWithBlockOnce:^(CLLocationManager *manager, CLAuthorizationStatus status) {
   }];
  
  return YES;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
  NSLog(@"application: handleEventsForBackgroundURLSession: completionHandler:");
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  NSLog(@"applicationDidBecomeActive:");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  NSLog(@"applicationDidEnterBackground:");
}

#pragma mark - Private

- (void)setup {
  [[UINavigationBar appearance] setBarTintColor:UIColor.barTintColor];
  [[UINavigationBar appearance] setTintColor:UIColor.tintColor];
  [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.tintColor}];
  
  UITabBarController *tabBarViewController = [[UITabBarController alloc] init];
  
  UINavigationController *homepage = [[UINavigationController alloc] initWithRootViewController:self.homePageViewController];
  homepage.tabBarItem =
  [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"tabbar-home-normal"] selectedImage:[UIImage imageNamed:@"tabbar-home-selected"]];
  homepage.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
  
  MSFUserViewController *userViewController = [[MSFUserViewController alloc] initWithStyle:UITableViewStylePlain];
  userViewController.title = @"个人中心";
  UINavigationController *userpage = [[UINavigationController alloc] initWithRootViewController:userViewController];
  userpage.tabBarItem =
  [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"tabbar-account-normal"] selectedImage:[UIImage imageNamed:@"tabbar-acount-selected"]];
  userpage.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
  
  UINavigationController *apply = [[UINavigationController alloc] initWithRootViewController:self.appliesPageViewController];
  apply.tabBarItem =
  [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"tabbar-apply-normal"] selectedImage:[UIImage imageNamed:@"tabbar-apply-selected"]];
  apply.tabBarItem.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
  
  tabBarViewController.viewControllers = @[homepage, apply,userpage];
  tabBarViewController.tabBar.selectedImageTintColor = UIColor.themeColor;
  tabBarViewController.delegate = self;
	self.tabBarController = tabBarViewController;
  
  self.window.rootViewController = tabBarViewController;
  
  __block NSDate *timeout;
  [[self rac_signalForSelector:@selector(applicationDidBecomeActive:)]
   subscribeNext:^(id x) {
     if ([NSDate.date timeIntervalSinceDate:timeout] > 3 * 60) {
       [MSFUtils cleanupArchive];
     }
   }];
  
  [[self rac_signalForSelector:@selector(applicationDidEnterBackground:)]
   subscribeNext:^(RACTuple *tuple) {
     timeout = NSDate.date;
   }];
  
  [[self rac_signalForSelector:@selector(applicationWillTerminate:)]
   subscribeNext:^(RACTuple *tuple) {
#if DEBUG
#else
     [MSFUtils cleanupArchive];
#endif
   }];
  
  @weakify(self)
  [[[NSNotificationCenter defaultCenter] rac_addObserverForName:MSFAuthorizationDidErrorNotification object:nil]
   subscribeNext:^(NSNotification *notification) {
     @strongify(self)
     NSError *error = notification.object;
     if ([error.userInfo[NSLocalizedFailureReasonErrorKey] isEqualToString:@"已在另一设备上登录，如非本人操作请立即修改密码"]) {
       [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
     }
     UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
     [tabBarController setSelectedIndex:0];
     [self signIn];
   }];
  
  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法连接到服务器"
   message:nil delegate:nil cancelButtonTitle:@"重新连接" otherButtonTitles:nil];
  [alertView.rac_buttonClickedSignal subscribeNext:^(id x) {
    @strongify(self)
    [MSFUtils.setupSignal subscribeNext:^(id x) {
      self.window.rootViewController = tabBarViewController;
			self.tabBarController = tabBarViewController;
    }];
  }];
  [[[NSNotificationCenter defaultCenter] rac_addObserverForName:MSFAuthorizationDidLoseConnectNotification object:nil]
   subscribeNext:^(id x) {
     if (!alertView.isVisible) {
       [alertView show];
     }
   }];
}

- (RACSignal *)signIn {
  @weakify(self)
  RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    @strongify(self)
		self.formsViewModel = nil;
    MSFLoginViewController *loginViewController = [[MSFLoginViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self.window.rootViewController presentViewController:navigationController animated:YES completion:nil];
    loginViewController.navigationItem.leftBarButtonItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStyleDone target:nil action:nil];
    @weakify(loginViewController);
    loginViewController.navigationItem.leftBarButtonItem.rac_command =
    [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      @strongify(loginViewController);
      [loginViewController dismissViewControllerAnimated:YES completion:nil];
      
      return [RACSignal empty];
    }];
    [subscriber sendCompleted];
    
    return [RACDisposable disposableWithBlock:^{
      [loginViewController.navigationItem.leftBarButtonItem.rac_command executionSignals];
    }];
  }];
  
  return [[signal replay] setNameWithFormat:@"`signIn`"];
}

- (RACSignal *)auth {
  return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
    MSFClozeViewController *clozeViewController =
    [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(MSFClozeViewController.class)];
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:clozeViewController];
    [self.window.rootViewController presentViewController:navigationController animated:YES completion:nil];
    [subscriber sendCompleted];
    
    return [RACDisposable disposableWithBlock:^{
      
    }];
  }] replay];
}

#pragma mark - Custom Accessors

- (UIBarButtonItem *)signInBarButtonItem {
  if (MSFUtils.httpClient.isAuthenticated) {
    return nil;
  }
  
  UIBarButtonItem *item =
  [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:nil action:nil];
  item.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    return [self signIn];
  }];
  
  return item;
}

- (MSFHomepageViewController *)homePageViewController {
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  MSFHomepageViewController *homePageViewController =
  [[MSFHomepageViewController alloc] initWithCollectionViewLayout:flowLayout];
  homePageViewController.title = @"马上贷";
  homePageViewController.navigationItem.leftBarButtonItem = self.signInBarButtonItem;
  
  @weakify(self)
  [[[NSNotificationCenter defaultCenter] rac_addObserverForName:MSFAuthorizationDidUpdateNotification object:nil]
   subscribeNext:^(NSNotification *notifi) {
     @strongify(self)
     MSFClient *client = notifi.object;
     if (client.isAuthenticated) {
       homePageViewController.navigationItem.leftBarButtonItem = nil;
     } else {
       homePageViewController.navigationItem.leftBarButtonItem =
       [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:nil action:nil];
       homePageViewController.navigationItem.leftBarButtonItem.rac_command =
       [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
         return [self signIn];
       }];
       UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
       [tabBarController setSelectedIndex:0];
     }
   }];
  
  homePageViewController.navigationItem.rightBarButtonItem =
  [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav-setting"] style:UIBarButtonItemStyleDone target:nil action:nil];
  @weakify(homePageViewController)
  homePageViewController.navigationItem.rightBarButtonItem.rac_command =
  [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    @strongify(homePageViewController)
    MSFSettingsViewController *settingsViewController = [[MSFSettingsViewController alloc] init];
    settingsViewController.hidesBottomBarWhenPushed = YES;
    [homePageViewController.navigationController pushViewController:settingsViewController animated:YES];
    
    return [RACSignal empty];
  }];
  
  [[homePageViewController rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:) fromProtocol:@protocol(UICollectionViewDelegate)] subscribeNext:^(RACTuple *collectionViewAndIndexPath) {
    @strongify(homePageViewController)
    @strongify(self)
    NSIndexPath *indexPath = collectionViewAndIndexPath.last;
    UICollectionViewCell *cell = [homePageViewController.collectionView cellForItemAtIndexPath:indexPath];
    if ([cell isKindOfClass:MSFPlaceholderCollectionViewCell.class]) {
      if (!MSFUtils.httpClient.isAuthenticated) {
        [self signIn];
      } else if (![MSFUtils.httpClient.user isAuthenticated]) {
        [self auth];
      } else {
        [(UITabBarController *)self.window.rootViewController setSelectedIndex:1];
      }
    }
  }];
  
  return homePageViewController;
}

- (UIViewController *)appliesPageViewController {
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"product" bundle:nil];
  return storyboard.instantiateInitialViewController;
}

- (void)displayProduct {
	[[MSFUtils.httpClient checkUserHasCredit] subscribeNext:^(MSFResponse *response) {
		if ([response.parsedResult[@"processing"] boolValue]) {
			[SVProgressHUD showInfoWithStatus:@"您的提交的申请已经在审核中，请耐心等待!"];
		} else {
			self.formsViewModel = [[MSFFormsViewModel alloc] init];
			self.formsViewModel.active = YES;
			@weakify(self)
			[SVProgressHUD showWithStatus:nil];
			[self.formsViewModel.updatedContentSignal subscribeNext:^(id x) {
				[SVProgressHUD dismiss];
				@strongify(self)
				MSFProductViewModel *viewModel = [[MSFProductViewModel alloc] initWithFormsViewModel:self.formsViewModel];
				MSFProductViewController *productViewController = [(UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:1] viewControllers].firstObject;
				[productViewController bindViewModel:viewModel];
				[self.tabBarController setSelectedIndex:1];
			}];
		}
	}];
}

#pragma mark - UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	// 登录验证
  if (![MSFUtils.httpClient isAuthenticated]) {
    [self signIn]; return NO;
	// 实名认证验证
  } else if (![MSFUtils.httpClient.user isAuthenticated]) {
    [self auth]; return NO;
  } else if ([tabBarController.viewControllers indexOfObjectIdenticalTo:viewController] == 1 && !self.formsViewModel) {
		[self displayProduct];
		return NO;
	}
	
  return YES;
}

@end
