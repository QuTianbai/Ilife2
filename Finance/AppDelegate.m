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

#import "MSFUtils.h"
#import "MSFUser.h"
#import "MSFReleaseNote.h"
#import "MSFClient+ReleaseNote.h"
#import "UIColor+Utils.h"

#import "RCLocationManager.h"

#import "MSFAuthorizeViewModel.h"
#import "MSFTabBarViewModel.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Masonry/Masonry.h>

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
//TODO: 测试无法获取时间戳的情况
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
		requestUserLocationWhenInUseWithBlockOnce:^(CLLocationManager *manager, CLAuthorizationStatus status) {}];
	
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
	
	MSFTabBarViewModel *viewModel = [[MSFTabBarViewModel alloc] init];
	self.tabBarController = [[MSFTabBarController alloc] initWithViewModel:viewModel];
	self.window.rootViewController = self.tabBarController;
	
	@weakify(self)
	[[self rac_signalForSelector:@selector(applicationDidBecomeActive:)]
		subscribeNext:^(id x) {
			@strongify(self)
			NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"expire-string-file"];
			NSString *string = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:path] encoding:NSUTF8StringEncoding];
			NSDate *date = [NSDate dateWithTimeIntervalSince1970:string.doubleValue];
			if ([NSDate.date timeIntervalSinceDate:date] > 3 * 60) {
				[MSFUtils cleanupArchive];
				[self.tabBarController.viewModel.authorizeViewModel.executeSignOut execute:nil];
			}
	 }];
	
	[[self rac_signalForSelector:@selector(applicationDidEnterBackground:)]
		subscribeNext:^(RACTuple *tuple) {
			 NSString *string = [@(NSDate.date.timeIntervalSince1970) stringValue];
			 NSString *path = [NSTemporaryDirectory() stringByAppendingString:@"expire-string-file"];
			 [string writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
		}];
	
	[[self rac_signalForSelector:@selector(applicationWillTerminate:)]
		subscribeNext:^(RACTuple *tuple) {
#if DEBUG
#else
		[MSFUtils cleanupArchive];
#endif
	 }];
}

@end
