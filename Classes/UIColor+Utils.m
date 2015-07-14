//
// UIColor+Utils.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "UIColor+Utils.h"
#import <UIColor-Hex/UIColor+Hex.h>

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
	return [UIColor colorWithHex:0x477dbd];
}

+ (UIColor *)tintColor {
	return [UIColor colorWithHex:0xffffff];
}

@end
