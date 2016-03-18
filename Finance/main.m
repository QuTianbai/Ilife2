//
//  main.m
//
//  Copyright (c) 2014 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TestAppDelegate.h"

int main(int argc, char *argv[]) {
  @autoreleasepool {
    BOOL isRunningTests = NSClassFromString(@"XCTestCase") != nil;
    Class appDelegateClass = isRunningTests ? [TestAppDelegate class] : [AppDelegate class];
    
    return UIApplicationMain(argc, argv, nil, NSStringFromClass(appDelegateClass));
  }
}
