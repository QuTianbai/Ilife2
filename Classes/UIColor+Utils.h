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

@end
