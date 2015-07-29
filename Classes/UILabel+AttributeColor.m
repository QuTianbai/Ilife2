//
//  UILabel+AttributeColor.m
//  Finance
//
//  Created by 赵勇 on 7/29/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "UILabel+AttributeColor.h"

@implementation UILabel(AttributeColor)

- (void) setText:(NSString *)text highLightText:(NSString *)hText highLightColor:(UIColor *)color {
	NSRange highLightRange = [text rangeOfString:hText];
	NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:text];
	[str addAttribute:NSForegroundColorAttributeName value:color range:highLightRange];;
	self.attributedText = str;
}

@end
