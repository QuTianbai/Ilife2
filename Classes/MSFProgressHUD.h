//
// MSFProgressHUD.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIView;

@interface MSFProgressHUD : NSObject

/**
 *  错误信息提示
 *
 *  @param message 提示内容
 *  @param view    视图(self.navigationController.view)
 */
+ (void)showErrorMessage:(NSString *)message inView:(UIView *)view;

/**
 *  成功信息提示
 *
 *  @param message 提示内容
 *  @param view    视图(self.navigationController.view)
 */
+ (void)showSuccessMessage:(NSString *)message inView:(UIView *)view;

/**
 *  进度信息提示
 *
 *  @param message 提示内容
 *  @param view    视图(self.navigationController.view)
 */
+ (void)showStatusMessage:(NSString *)message inView:(UIView *)view;

/**
 *  隐藏提示信息
 */
+ (void)hidden;

@end
