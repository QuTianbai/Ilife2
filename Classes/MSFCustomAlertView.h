//
//  CustomAlertView.h
//  alert
//
//  Created by xbm on 15/9/1.
//  Copyright (c) 2015年 xbm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSFConfirmContactViewModel;

extern NSString *const MSFREQUESTCONTRACTSNOTIFACATION;
extern NSString *const MSFCONFIRMCONTACTNOTIFACATION;
extern NSString *const MSFCONFIRMCONTACTIONLATERNOTIFICATION;

@interface MSFCustomAlertView : UIWindow

- (instancetype)initAlertViewWithFrame:(CGRect)frame  AndTitle:(NSString *)title AndMessage:(NSString *)message AndImage:(UIImage *)image andCancleButtonTitle:(NSString *)cancleButton AndConfirmButtonTitle:(NSString *)confirmTitle;

- (void)showWithViewModel:(MSFConfirmContactViewModel *)viewmodel;
- (void)dismiss;

@end
