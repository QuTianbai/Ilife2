//
// MSFTabBarController.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSFTabBarViewModel;

@interface MSFTabBarController : UITabBarController <UITabBarControllerDelegate>

@property (nonatomic, weak, readonly) MSFTabBarViewModel *viewModel;

- (instancetype)initWithViewModel:(MSFTabBarViewModel *)viewModel;

@end
