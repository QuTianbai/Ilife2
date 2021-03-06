//
//  AppDelegate.m
//
//  Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "AppDelegate.h"
#import <Mantle/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MSFTabBarController.h"
#import "MSFGuideViewController.h"

#import "MSFActivate.h"
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
#import "MSFActivityIndicatorViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFCustomAlertView.h"
#import "MSFConfirmContractViewModel.h"
#import "MSFAuthorizeViewModel.h"
#import "MSFEnvironmentsViewController.h"
#import "UIImage+Color.h"
#import "MSFSignInViewController.h"
#import "MSFSelectProductViewController.h"

#if TEST
#import <BugshotKit/BugshotKit.h>
#endif

@interface AppDelegate ()

@property (nonatomic, strong) MSFViewModelServicesImpl *viewModelServices;
@property (nonatomic, strong) MSFConfirmContractViewModel *confirmContactViewModel;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) MSFReleaseNote *releaseNote;

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.window.backgroundColor = UIColor.whiteColor;
	self.window.rootViewController = [[MSFActivityIndicatorViewController alloc] init];
	[self.window makeKeyAndVisible];
	
	[UIApplication.sharedApplication setStatusBarHidden:NO];
	[UIApplication.sharedApplication setStatusBarStyle:UIStatusBarStyleLightContent];
	[UINavigationBar.appearance setTintColor:UIColor.whiteColor];
	[UINavigationBar.appearance setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.whiteColor}];
	
	[UINavigationBar.appearance setBarTintColor:UIColor.navigationBarColor];
	if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
		
		[UINavigationBar.appearance setTranslucent:YES];
		[UINavigationBar.appearance setClipsToBounds:YES];
	}
	[UINavigationBar.appearance setShadowImage:UIImage.new];
	[UINavigationBar.appearance setBackIndicatorImage:[UIImage imageWithColor:UIColor.navigationBarColor size:CGSizeMake(1, 44)]];

	
	@weakify(self)
	[RACObserve(self.window, rootViewController) subscribeNext:^(id x) {
		@strongify(self)
		UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), 20)];
		view.backgroundColor = UIColor.blackColor;
		[self.window.rootViewController.view addSubview:view];
	}];
	
	[Fabric with:@[CrashlyticsKit]];
	
#if TEST
	[BugshotKit enableWithNumberOfTouches:2 performingGestures:(BSKInvocationGestureSwipeFromRightEdge | BSKInvocationGestureSwipeUp) feedbackEmailAddress:@"ios@msxf.com"];
	[[BugshotKit sharedManager] setDisplayConsoleTextInLogViewer:YES];
#endif
	// ViewModels
	self.viewModelServices = [[MSFViewModelServicesImpl alloc] init];
	self.viewModel = [[MSFTabBarViewModel alloc] initWithServices:self.viewModelServices];
	self.authorizeVewModel = self.viewModel.authorizeViewModel;
	
	 //由于取消首页引导图, 定位地址信息权限获取重写到程序启动
	[[RCLocationManager sharedManager] requestUserLocationAlwaysOnce:^(CLLocationManager *manager, CLAuthorizationStatus status) {
		[manager startUpdatingLocation];
	}];

	[[MSFActivate.setupSignal catch:^RACSignal *(NSError *error) {
		[self setup];
		[MSFGuideViewController.guide show];
		return RACSignal.empty;
	}] subscribeNext:^(MSFReleaseNote *releasenote) {
		[self setup];
		[MSFGuideViewController.guide show];
		#if !DEBUG
		if (MSFActivate.poster) {
			[NSThread sleepForTimeInterval:3];
		}
		#endif
		self.releaseNote = releasenote;
		[self updateCheck];
	}];
	
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	if (self.releaseNote) [self updateCheck];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	if (self.timer != nil) {
		[self.timer setFireDate:[NSDate distantFuture]];
	}
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler {
}

#pragma mark - Private

- (void)updateCheck {
	[MobClick event:MSF_Umeng_Statistics_TaskId_CheckUpdate attributes:nil];
	if (self.releaseNote.isUpdated) return;
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

- (void)updateContract {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFREQUESTCONTRACTSNOTIFACATION" object:nil];
}

#pragma mark - Setup

- (void)setup {
	// 通用颜色配置
	
  [SVProgressHUD setBackgroundColor:[UIColor colorWithHue:0 saturation:0 brightness:0.95 alpha:0.8]];
	
	// 启动到登录的过渡动画
	CATransition *transition = [CATransition animation];
	transition.duration = 0.7;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionFade;
	transition.subtype = kCATransitionReveal;
	[self.window.layer addAnimation:transition forKey:nil];
	
	// 加载未授权界面
	[self unAuthenticatedControllers];
	
	@weakify(self)
	
	// 登录注册验证变化
	[self.viewModel.authorizationUpdatedSignal subscribeNext:^(MSFClient *client) {
		@strongify(self)
		if (client.isAuthenticated) {
			[self authenticatedControllers];
		} else {
			[self unAuthenticatedControllers];
		}
	}];
	
	// 超时授权失败
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:MSFClientErrorAuthenticationFailedNotification object:nil] subscribeNext:^(NSError *error) {
		@strongify(self)
		[self unAuthenticatedControllers];
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	// 更多配置
	[self umengSetup];
	[self contractSetup];
}

- (void)contractSetup {
	// 确认合同
	@weakify(self)
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:MSFREQUESTCONTRACTSNOTIFACATION object:nil] subscribeNext:^(id x) {
		@strongify(self)
		
		self.confirmContactWindow = [[MSFCustomAlertView alloc] initAlertViewWithFrame:[[UIScreen mainScreen] bounds] AndTitle:@"恭喜您" AndMessage:@"合同已通过我们的审核，赶紧去确认合同吧！" AndImage:[UIImage imageNamed:@"icon-confirm"] andCancleButtonTitle:@"稍后确认" AndConfirmButtonTitle:@"立即确认"];
		if (self.confirmContactViewModel == nil) {
			self.confirmContactViewModel = [[MSFConfirmContractViewModel alloc] initWithServers:self.viewModel.services];
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
}

- (void)umengSetup {
	// 添加Umeng统计
	NSString *umengAppKey = nil;
#if DEBUG
	umengAppKey = MSF_Umeng_AppKey_Test;
#else
	umengAppKey = MSF_Umeng_AppKey;
#endif
	[MobClick startWithAppkey:umengAppKey reportPolicy:BATCH channelId:nil];
	[MobClick setAppVersion:[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]];
}

#pragma mark - Authenticated

- (void)unAuthenticatedControllers {
	if (self.timer != nil) {
		[self.timer setFireDate:[NSDate distantFuture]];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:MSFCONFIRMCONTACTIONLATERNOTIFICATION object:nil];
	MSFSignInViewController *viewController = [[MSFSignInViewController alloc] initWithViewModel:self.viewModel.authorizeViewModel];
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	self.window.rootViewController = navigationController;

	//!!!: 临时处理方案，解决在iOS7设备上无法直接显示注册／登录空间的问题
	if ([[[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."].firstObject floatValue] < 8) {
		UIViewController *vc = [[UINavigationController alloc] initWithRootViewController:[[MSFEnvironmentsViewController alloc] init]];
		[self.window.rootViewController presentViewController:vc animated:NO completion:nil];
		[vc dismissViewControllerAnimated:NO completion:nil];
	}
}

- (void)authenticatedControllers {
    MSFSelectProductViewController *selectViewController = [[MSFSelectProductViewController alloc] initWithServices:self.viewModel.services];
    MSFUser *user = self.viewModelServices.httpClient.user;
    __block UITabBarController *tabBarController = [[MSFTabBarController alloc] initWithViewModel:self.viewModel];
    if ([user.custType isEqualToString:@"1"]) {
        UITabBarController *tabBarController = [[MSFTabBarController alloc] initWithViewModel:self.viewModel];
        [selectViewController returnBabBarWithBlock:^void(NSString *str) {
            tabBarController.selectedIndex = str.intValue;
            self.window.rootViewController = tabBarController;
        }];
        self.window.rootViewController = selectViewController;
        
    } else {
        tabBarController.selectedIndex = 0;
        self.window.rootViewController = tabBarController;
    }
}

#if TEST

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	CGPoint location = [[[event allTouches] anyObject] locationInView:[self window]];
	CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
	if (CGRectContainsPoint(statusBarFrame, location)) {
		[self statusBarTouchedAction];
	}
}

- (void)statusBarTouchedAction {
	[self.window.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:[[MSFEnvironmentsViewController alloc] init]] animated:YES completion:nil];
}

#endif

@end
