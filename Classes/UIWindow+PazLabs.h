//
// UIWindow+PazLabs.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (PazLabs)

// Return top/presented view controller if it exists.
- (UIViewController *)visibleViewController;

@end
