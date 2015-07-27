//
// MSFTabBarController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFReactiveView.h"

@class MSFTabBarViewModel;

@interface MSFTabBarController : UITabBarController <UITabBarControllerDelegate, MSFReactiveView>

@property (nonatomic, weak, readonly) MSFTabBarViewModel *viewModel;

- (instancetype)initWithViewModel:(MSFTabBarViewModel *)tabBarViewModel;

@end
