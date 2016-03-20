//
//  MSFBlankCell.m
//  Finance
//
//  Created by 赵勇 on 9/9/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFBlankCell.h"
#import "UIColor+Utils.h"

@implementation MSFBlankCell

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		self.backgroundColor = [UIColor whiteColor];
	}
	return self;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(context, 0, rect.size.height);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
	CGContextSetLineWidth(context, 0.5);
	[[UIColor borderColor] setStroke];
	CGContextStrokePath(context);
}

@end
