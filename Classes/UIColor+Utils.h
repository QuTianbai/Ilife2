//
// UIColor+Utils.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utils)

+ (UIColor *)themeColor;
+ (UIColor *)fontColor;

+ (UIColor *)backgroundColor;
+ (UIColor *)darkBackgroundColor;

// 导航条背景颜色
+ (UIColor *)barTintColor;

// 导航条文字颜色
+ (UIColor *)tintColor;

// 边框颜色
+ (UIColor *)borderColor;

// 提交按钮颜色
+ (UIColor *)buttonNormalColor;
+ (UIColor *)buttonDisableColor;
+ (UIColor *)buttonSelectedColor;

// 文字颜色
+ (UIColor *)fontHighlightedColor;
+ (UIColor *)fontNormalColor;

//新主题色a0defe
+ (UIColor *)themeColorNew;
+ (UIColor *)color666666;
+ (UIColor *)color999999;

//MSFLoanLimitView
+ (UIColor *)darkCircleColor;
+ (UIColor *)lightCircleColor;
+ (UIColor *)lineColor;
+ (UIColor *)repaymentTextColor;
+ (UIColor *)overDueTextColor;

//MSFUserInfoCircleView
+ (UIColor *)uncompletedColor;
+ (UIColor *)completedColor;
+ (UIColor *)percentColor;

//msd-full
+ (UIColor *)msdFullBackgroundColor;

// SignInButton BG Color
+ (UIColor *)signInBgClolr;

// button BG color
+ (UIColor *)buttonBgColor;

//button border color
+ (UIColor *)buttonBorderColor;

//navigationBar BG color
+ (UIColor *)navigationBgColor;

//captchbutton bg gray
+ (UIColor *)captchButtonBgColor;

//signUp BG Color
+ (UIColor *)signUpBgcolor;

@end
