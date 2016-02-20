//
// UIColor+Utils.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "UIColor+Utils.h"
#import <UIColor-Hex/UIColor+Hex.h>
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"

@implementation UIColor (Utils)

+ (UIColor *)themeColor {
	return [UIColor colorWithHex:0x477DBD];
}

+ (UIColor *)fontColor {
	return [UIColor whiteColor];
}

+ (UIColor *)borderColor {
	return [UIColor colorWithRed:0.682 green:0.686 blue:0.686 alpha:0.820];
}

+ (UIColor *)backgroundColor {
	return [UIColor colorWithHex:0xDCE6F2];
}

+ (UIColor *)darkBackgroundColor {
	return [UIColor colorWithHex:0xF1F1F1];
}

+ (UIColor *)barTintColor {
	return [UIColor whiteColor];
}

+ (UIColor *)tintColor {
  return [MSFCommandView getColorWithString:@"#0babed"];
}

+ (UIColor *)buttonNormalColor {
	return [UIColor colorWithRed:0.047 green:0.404 blue:0.875 alpha:1.000];
}

+ (UIColor *)buttonDisableColor {
	return [UIColor colorWithRed:0.255 green:0.506 blue:0.784 alpha:1.000];
}

+ (UIColor *)buttonSelectedColor {
	return [UIColor colorWithRed:0.231 green:0.455 blue:0.710 alpha:1.000];
}

+ (UIColor *)fontHighlightedColor {
	return [UIColor colorWithRed:0.047 green:0.404 blue:0.875 alpha:1.000];
}

+ (UIColor *)fontNormalColor {
	return [UIColor colorWithWhite:0.529 alpha:1.000];
}

+ (UIColor *)themeColorNew {
	return [UIColor colorWithHex:0x0babed];
}

+ (UIColor *)separatorColor {
	return [UIColor colorWithHex:0xE1E1E1];
}

+ (UIColor *)darkCircleColor {
	return [UIColor colorWithHex:0x50CDEC];
}

+ (UIColor *)lightCircleColor {
	return [UIColor colorWithHex:0x99dfff];
}

+ (UIColor *)lineColor {
	return [UIColor colorWithHex:0xe1e1e1];
}

+ (UIColor *)repaymentTextColor {
	return [UIColor colorWithHex:0x999999];
}

+ (UIColor *)overDueTextColor {
	return [UIColor colorWithHex:0xfda609];
}

+ (UIColor *)color666666 {
	return [UIColor colorWithHex:0x666666];
}

+ (UIColor *)color999999 {
	return [UIColor colorWithHex:0x999999];
}

+ (UIColor *)uncompletedColor {
	return [UIColor colorWithHex:0xe8e8e8];
}

+ (UIColor *)completedColor {
	return [UIColor colorWithHex:0x0babed];
}

+ (UIColor *)percentColor {
	return [UIColor colorWithHex:0xff6600];
}

+ (UIColor *)msdFullBackgroundColor {
	return [UIColor colorWithHex:0x1ab5f5];
}

+ (UIColor *)signInBgClolr {
	return [MSFCommandView getColorWithString:@"#0077ba"];
}

+ (UIColor *)buttonBgColor {
	return [MSFCommandView getColorWithString:@"#0ea5fd"];
}

+ (UIColor *)buttonBorderColor {
	return [MSFCommandView getColorWithString:@"#74cdff"];
}

+ (UIColor *)navigationBgColor {
	return [MSFCommandView getColorWithString:@"#12A6FB"];
}

@end
