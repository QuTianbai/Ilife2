//
// TestAppDelegate.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "TestAppDelegate.h"

@implementation TestAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  [self.window makeKeyAndVisible];
  
  return YES;
}

@end
