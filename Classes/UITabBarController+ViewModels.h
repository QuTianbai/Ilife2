//
// UITabBarController+ViewModels.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSFTabBarViewModel;

@interface UITabBarController (ViewModels)

@property (nonatomic, readonly) MSFTabBarViewModel *viewModel;

@end
