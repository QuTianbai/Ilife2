//
//  MSFExtraOptionCell.m
//  Finance
//
//  Created by 赵勇 on 9/2/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFExtraOptionCell.h"
#import "UIColor+Utils.h"

@implementation MSFExtraOptionCell

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, rect.size.width, 0);
	CGContextMoveToPoint(context, 0, rect.size.height);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
	CGContextSetLineWidth(context, 0.5);
	[[UIColor borderColor] setStroke];
	CGContextStrokePath(context);
}

@end
