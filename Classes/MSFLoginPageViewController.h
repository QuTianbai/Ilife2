//
// MSFPageViewController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSPageViewController.h"
#import "MSPageViewController+Protected.h"

__attribute__((deprecated("This class is unavailable")))

@interface MSFLoginPageViewController : MSPageViewController <UIPageViewControllerDelegate>

@property (nonatomic, assign) BOOL dragging;
@property (nonatomic, assign, readonly) CGFloat offset;

@end
