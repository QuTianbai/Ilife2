//
//  UIImage+Color.m
//  Finance
//
//  Created by xbm on 16/2/20.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, color.CGColor);
	CGContextFillRect(context, rect);
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return img;
}

@end
