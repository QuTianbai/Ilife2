//
//	MSFCommandView.m
//	Cash
//
//	Created by xbm on 15/5/18.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFCommandView.h"

@implementation MSFCommandView

#pragma mark 根据16进制数获得颜色
+ (UIColor *)getColorWithString:(NSString *)stringToConvert {
	NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	// String should be 6 or 8 charactersif ([cString length] < 6) return [UIColor blackColor];
	// strip 0X if it appearsif ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
	if ([cString hasPrefix:@"#"]) {
		cString = [cString substringFromIndex:1];
	}
	if ([cString length] != 6) {
	 return [UIColor blackColor];
	}
	
	// Separate into r, g, b substrings
	NSRange range = NSMakeRange(0, 0);
	range.location = 0;
	range.length = 2;
	NSString *rString = [cString substringWithRange:range];
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	// Scan values
	unsigned int r, g, b;
	
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float) r / 255.0f)
												 green:((float) g / 255.0f)
													blue:((float) b / 255.0f)
												 alpha:1.0f];
}

#pragma mark 创建button按钮

+ (UIButton *)createButtonWithTitle:(NSString *)title backgroundClolr:(UIColor *)bgColor titleColor:(UIColor *)titleColor frame:(CGRect)frame selectedTitleColor:(UIColor *)seletTitleColor tag:(int)tag backImg:(UIImage *)img delegate:(id)delegate titleFont:(UIFont *)font {
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	button.backgroundColor = bgColor;
	[button setTitle:title forState:UIControlStateNormal];
	[button setTitleColor:titleColor forState:UIControlStateNormal];
	[button setTitleColor:seletTitleColor forState:UIControlStateSelected];
	button.titleLabel.font = font;
	[button setBackgroundImage:img forState:UIControlStateNormal];
	button.tag = tag;
	//[button addTarget:delegate action:@selector(buttonOnCLicked:) forControlEvents:UIControlEventTouchUpInside];
	
	return button;
}

#pragma mark 创建label显示

+ (UILabel *)createLabelWithTitle:(NSString *)title backgroundColor:(UIColor *)color titleColor:(UIColor *)titleColor frame:(CGRect)frame tag:(int)tag {
	UILabel *label = [[UILabel alloc]initWithFrame:frame];
	label.text = title;
	label.textColor = titleColor;
	label.backgroundColor = color;
	label.tag = tag;
	label.textAlignment = NSTextAlignmentCenter;
	
	return label; 
}

#pragma mark 创建TextFiled

+ (UITextField *)createTextFiled:(NSString *)text placeTitle:(NSString *)placeTitle frame:(CGRect)frame backgroungColor:(UIColor *)bgColor tag:(int)tag delegate:(id)delegate {
	UITextField *textField = [[UITextField alloc] initWithFrame:frame];
	textField.placeholder = placeTitle;
	textField.backgroundColor = bgColor;
	textField.tag = tag;
	textField.text = text;
	textField.delegate = delegate;
	textField.borderStyle = UITextBorderStyleRoundedRect;
	
	return textField;
}

@end
