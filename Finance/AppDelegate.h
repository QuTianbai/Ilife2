//
//  AppDelegate.h
//  Cash
//
//  Created by gitmac on 5/14/15.
//  Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSFCustomAlertView;
@class MSFAuthorizeViewModel;
@class MSFTabBarViewModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) MSFCustomAlertView *confirmContactWindow;
@property (nonatomic, strong) MSFAuthorizeViewModel *authorizeVewModel;
@property (nonatomic, strong) MSFTabBarViewModel *viewModel;

@end

