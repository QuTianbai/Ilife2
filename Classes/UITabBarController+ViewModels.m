//
// UITabBarController+ViewModels.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "UITabBarController+ViewModels.h"
#import "AppDelegate.h"

@implementation UITabBarController (ViewModels)

- (MSFTabBarViewModel *)viewModel {
	return [(AppDelegate *)[UIApplication sharedApplication].delegate viewModel];
}

@end
