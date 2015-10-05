//
//  AppDelegate.m
//
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
#import "MSFCustomAlertView.h"
#import "MSFConfirmContactViewModel.h"
#import <BugshotKit/BugshotKit.h>


@interface AppDelegate ()

@property (nonatomic, strong) MSFTabBarViewModel *viewModel;
@property (nonatomic, strong) MSFViewModelServicesImpl *viewModelServices;
@property (nonatomic, strong) MSFConfirmContactViewModel *confirmContactViewModel;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) MSFReleaseNote *releaseNote;

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[Fabric with:@[CrashlyticsKit]];
  [SVProgressHUD setBackgroundColor:[UIColor colorWithHue:0 saturation:0 brightness:0.95 alpha:0.8]];
	
#if TEST || DEBUG
	[BugshotKit enableWithNumberOfTouches:2 performingGestures:(BSKInvocationGestureSwipeFromRightEdge | BSKInvocationGestureSwipeUp) feedbackEmailAddress:@"liang.zeng@msxf.com"];
#endif
	
	// 由于取消首页引导图, 定位地址信息权限获取重写到程序启动
	[[RCLocationManager sharedManager] requestUserLocationAlwaysOnce:^(CLLocationManager *manager, CLAuthorizationStatus status) {
		[manager startUpdatingLocation];
	}];
	
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.window.backgroundColor = UIColor.whiteColor;
	self.window.rootViewController = [[MSFActivityIndicatorViewController alloc] init];
	[self.window makeKeyAndVisible];
	
	// 确认合同
	@weakify(self)
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:MSFREQUESTCONTRACTSNOTIFACATION object:nil] subscribeNext:^(id x) {
		@strongify(self)
		
		self.confirmContactWindow = [[MSFCustomAlertView alloc] initAlertViewWithFrame:[[UIScreen mainScreen] bounds] AndTitle:@"恭喜您" AndMessage:@"合同已通过我们的审核，赶紧去确认合同吧！" AndImage:[UIImage imageNamed:@"icon-confirm"] andCancleButtonTitle:@"稍后确认" AndConfirmButtonTitle:@"立即确认"];
		if (self.confirmContactViewModel == nil) {
			self.confirmContactViewModel = [[MSFConfirmContactViewModel alloc] initWithServers:self.viewModel.services];
		} else {
			[self.confirmContactViewModel fetchContractist];
		}
	}];
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:MSFCONFIRMCONTACTNOTIFACATION object:nil] subscribeNext:^(id x) {
		@strongify(self)
		if (self.timer != nil) {
			[self.timer setFireDate:[NSDate distantFuture]];
		}
		[self.confirmContactWindow showWithViewModel:self.confirmContactViewModel];
	}];
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:MSFCONFIRMCONTACTIONLATERNOTIFICATION object:nil] subscribeNext:^(id x) {
		@strongify(self)
		if (self.confirmContactWindow != nil) {
			[self.confirmContactWindow dismiss];
			self.confirmContactWindow = nil;
			[self.window makeKeyAndVisible];
		}
		
	}];
	
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"REFRASHTIMERCONTRACT" object:nil] subscribeNext:^(id x) {
		@strongify(self)
		self.timer = [NSTimer scheduledTimerWithTimeInterval:60 * 3 target:self selector:@selector(updateContract) userInfo:nil repeats:YES];
	}];
	
	
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
	}] subscribeNext:^(MSFReleaseNote *releasenote) {
		[self setup];
		self.releaseNote = releasenote;
		[MobClick event:MSF_Umeng_Statistics_TaskId_CheckUpdate attributes:nil];
		if (releasenote.status == 1) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"升级提示"
				message:releasenote.summary delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
			[alert show];
			[alert.rac_buttonClickedSignal subscribeNext:^(id x) {
				[[UIApplication sharedApplication] openURL:releasenote.updatedURL];
			}];
		} else if (releasenote.status == 2) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"升级提示"
				message:releasenote.summary delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
			[alert show];
			[alert.rac_buttonClickedSignal subscribeNext:^(id x) {
				if ([x integerValue] == 1) [[UIApplication sharedApplication] openURL:releasenote.updatedURL];
			}];
		}
	}];
	
	return YES;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
	NSLog(@"application: handleEventsForBackgroundURLSession: completionHandler:");
	
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	NSLog(@"applicationDidBecomeActive:");
	if (self.releaseNote) [self updateCheck];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	if (self.timer != nil) {
		[self.timer setFireDate:[NSDate distantFuture]];
	}
	NSLog(@"applicationDidEnterBackground:");
}

#pragma mark - Private

- (void)updateCheck {
	[MobClick event:MSF_Umeng_Statistics_TaskId_CheckUpdate attributes:nil];
	if (self.releaseNote.status == 1) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"升级提示"
			message:self.releaseNote.summary delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
		[alert show];
		[alert.rac_buttonClickedSignal subscribeNext:^(id x) {
			[[UIApplication sharedApplication] openURL:self.releaseNote.updatedURL];
		}];
	} else if (self.releaseNote.status == 2) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"升级提示"
			message:self.releaseNote.summary delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
		[alert show];
		[alert.rac_buttonClickedSignal subscribeNext:^(id x) {
			if ([x integerValue] == 1) [[UIApplication sharedApplication] openURL:self.releaseNote.updatedURL];
		}];
	}
}

- (void)setup {
	[[UINavigationBar appearance] setBarTintColor:UIColor.barTintColor];
	[[UINavigationBar appearance] setTintColor:UIColor.tintColor];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.tintColor}];
	
	self.viewModelServices = [[MSFViewModelServicesImpl alloc] init];
	self.viewModel = [[MSFTabBarViewModel alloc] initWithServices:self.viewModelServices];
	self.authorizeVewModel = self.viewModel.authorizeViewModel;
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
	
	// Error Handle
	[[[[NSNotificationCenter defaultCenter] rac_addObserverForName:MSFClientErrorAuthenticationFailedNotification object:nil]
		takeUntil:self.rac_willDeallocSignal]
		subscribeNext:^(NSNotification *notification) {
			@strongify(self)
			NSError *error = notification.object;
			UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message: error.userInfo[NSLocalizedFailureReasonErrorKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
			[self unAuthenticatedControllers];
			[MSFUtils setHttpClient:nil];
			if (alertView.isVisible) return;
			[alertView show];
		}];
}

- (void)unAuthenticatedControllers {
	if (self.timer != nil) {
		[self.timer setFireDate:[NSDate distantFuture]];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:MSFCONFIRMCONTACTIONLATERNOTIFICATION object:nil];
	MSFLoginViewController *viewController = [[MSFLoginViewController alloc] initWithViewModel:self.viewModel.authorizeViewModel];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	self.window.rootViewController = navigationController;
}

- (void)authenticatedControllers {
	UITabBarController *tabBarController = [[MSFTabBarController alloc] initWithViewModel:self.viewModel];
	self.window.rootViewController = tabBarController;
}

- (void)updateContract {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFREQUESTCONTRACTSNOTIFACATION" object:nil];
}

@end
