//
//  AppDelegate.h
//  Cash
//
//  Created by gitmac on 5/14/15.
//  Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSFAuthorizeViewModel.h"

@class MSFCustomAlertView;
//@class MSFAuthorizeViewModel;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) MSFCustomAlertView *confirmContactWindow;

@property (nonatomic, strong) MSFAuthorizeViewModel *authorizeVewModel;

@end

