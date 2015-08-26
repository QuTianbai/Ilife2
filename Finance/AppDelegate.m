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

#import "MSFTabBarController.h"
#import "MSFGuideViewController.h"
#import "MSFLoginViewController.h"

#import "MSFUtils.h"
#import "MSFUser.h"
#import "MSFReleaseNote.h"
#import "MSFClient+ReleaseNote.h"
#import "UIColor+Utils.h"

#import "RCLocationManager.h"

#import "MSFAuthorizeViewModel.h"
#import "MSFTabBarViewModel.h"
#import "MSFViewModelServicesImpl.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Masonry/Masonry.h>

#import "MobClick.h"
#import "MSFUmengMacro.h"
#import "MSFVersion.h"
#import "MSFActivityIndicatorViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFUtilsViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) MSFTabBarViewModel *viewModel;
@property (nonatomic, strong) MSFViewModelServicesImpl *viewModelServices;

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[Fabric with:@[CrashlyticsKit]];
  
  [SVProgressHUD setBackgroundColor:[UIColor colorWithHue:0 saturation:0 brightness:0.95 alpha:0.8]];
  
	// 由于取消首页引导图, 定位地址信息权限获取重写到程序启动
	[[RCLocationManager sharedManager] requestUserLocationAlwaysOnce:^(CLLocationManager *manager, CLAuthorizationStatus status) {
		[manager startUpdatingLocation];
	}];
	
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.window.backgroundColor = UIColor.whiteColor;
	self.window.rootViewController = [[MSFActivityIndicatorViewController alloc] init];
	[self.window makeKeyAndVisible];
	
	///添加Umeng统计
	NSString *umengAppKey = nil;
#if DEBUG
	umengAppKey = MSF_Umeng_AppKey_Test;
#else
	umengAppKey = MSF_Umeng_AppKey;
#endif
	[MobClick startWithAppkey:umengAppKey reportPolicy:BATCH channelId:nil];
	[MobClick setAppVersion:[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
	
	[[MSFUtils.setupSignal catch:^RACSignal *(NSError *error) {
		[self setup];
		return [RACSignal empty];
	}] subscribeNext:^(id x) {
		[self setup];
	}];
	
	return YES;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
	NSLog(@"application: handleEventsForBackgroundURLSession: completionHandler:");
	
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	NSLog(@"applicationDidBecomeActive:");
	[[MSFUtils.httpClient fetchReleaseNote] subscribeNext:^(MSFReleaseNote *releasenote) {
		[MobClick event:MSF_Umeng_Statistics_TaskId_CheckUpdate attributes:nil];
		if (releasenote.status == 1) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"升级提示"
				message:releasenote.version.summary delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
			[alert show];
			[alert.rac_buttonClickedSignal subscribeNext:^(id x) {
				[[UIApplication sharedApplication] openURL:releasenote.version.updateURL];
			}];
		} else if (releasenote.status == 2) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"升级提示"
				message:releasenote.version.summary delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
			[alert show];
			[alert.rac_buttonClickedSignal subscribeNext:^(id x) {
				if ([x integerValue] == 1) [[UIApplication sharedApplication] openURL:releasenote.version.updateURL];
			}];
		}
	}];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	NSLog(@"applicationDidEnterBackground:");
}

#pragma mark - Private

- (void)setup {
	[[UINavigationBar appearance] setBarTintColor:UIColor.barTintColor];
	[[UINavigationBar appearance] setTintColor:UIColor.tintColor];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.tintColor}];
	
	self.viewModelServices = [[MSFViewModelServicesImpl alloc] init];
	self.viewModel = [[MSFTabBarViewModel alloc] initWithServices:self.viewModelServices];
	CATransition *transition = [CATransition animation];
	transition.duration = 0.7;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	transition.subtype = kCATransitionReveal;
	[self.window.layer addAnimation:transition forKey:nil];
	[self unAuthenticatedControllers];
	
	@weakify(self)
	[self.viewModel.authorizationUpdatedSignal subscribeNext:^(MSFClient *client) {
		@strongify(self)
		if (client.isAuthenticated) {
			[self authenticatedControllers];
		} else {
			[self unAuthenticatedControllers];
		}
	}];
	
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:MSFUtilsURLDidUpdateNotification object:nil] subscribeNext:^(id x) {
		self.viewModelServices = [[MSFViewModelServicesImpl alloc] init];
		self.viewModel = [[MSFTabBarViewModel alloc] initWithServices:self.viewModelServices];
		[self unAuthenticatedControllers];
		[self.viewModel.authorizationUpdatedSignal subscribeNext:^(MSFClient *client) {
			@strongify(self)
			if (client.isAuthenticated) {
				[self authenticatedControllers];
			} else {
				[self unAuthenticatedControllers];
			}
		}];
	}];
	
	// Timeout Handle
	[[self rac_signalForSelector:@selector(applicationDidBecomeActive:)]
		subscribeNext:^(id x) {
			@strongify(self)
			NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"expire-string-file"];
			NSString *string = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:path] encoding:NSUTF8StringEncoding];
			NSDate *date = [NSDate dateWithTimeIntervalSince1970:string.doubleValue];
			if ([NSDate.date timeIntervalSinceDate:date] > 3 * 60) {
				[self.viewModel.authorizeViewModel.executeSignOut execute:nil];
			}
	 }];
	
	[[self rac_signalForSelector:@selector(applicationDidEnterBackground:)]
		subscribeNext:^(RACTuple *tuple) {
			NSString *string = [@(NSDate.date.timeIntervalSince1970) stringValue];
			NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"expire-string-file"];
			[string writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
		}];
	
	// Error Handle
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
																											message:@"已在另一设备上登录，如非本人操作请立即修改密码"
																										 delegate:nil
																						cancelButtonTitle:nil
																						otherButtonTitles:@"确定", nil];
	[[[[NSNotificationCenter defaultCenter]
		 rac_addObserverForName:MSFAuthorizationDidErrorNotification object:nil]
		takeUntil:self.rac_willDeallocSignal]
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
																											 message:nil
																											delegate:nil
																						 cancelButtonTitle:@"重新连接"
																						 otherButtonTitles:nil];
	[alertView2.rac_buttonClickedSignal subscribeNext:^(id x) {
		[MSFUtils.setupSignal subscribeNext:^(id x) {
			[self unAuthenticatedControllers];
		}];
	}];
	[[[NSNotificationCenter defaultCenter]
		rac_addObserverForName:MSFAuthorizationDidLoseConnectNotification object:nil]
		subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			if (!alertView2.isVisible) {
				[alertView2 show];
			}
		}];
}

- (void)unAuthenticatedControllers {
	MSFLoginViewController *viewController = [[MSFLoginViewController alloc] initWithViewModel:self.viewModel.authorizeViewModel];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	self.window.rootViewController = navigationController;
}

- (void)authenticatedControllers {
	UITabBarController *tabBarController = [[MSFTabBarController alloc] initWithViewModel:self.viewModel];
	self.window.rootViewController = tabBarController;
}

#pragma mark - Status bar touch tracking

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	CGPoint location = [[[event allTouches] anyObject] locationInView:[self window]];
	CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
	if (CGRectContainsPoint(statusBarFrame, location)) {
		[self statusBarTouchedAction];
	}
}

- (void)statusBarTouchedAction {
	MSFUtilsViewController *vc = [[MSFUtilsViewController alloc] initWithStyle:UITableViewStylePlain];
	[self.window.rootViewController presentViewController:vc animated:YES completion:nil];
}

@end
