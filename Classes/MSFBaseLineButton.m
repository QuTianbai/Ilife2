//
//  MSFBaseLineButton.m
//  Finance
//
//  Created by administrator on 16/3/28.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFBaseLineButton.h"

@interface MSFBaseLineButton(){
    
    UIColor *baseLineColor;
}

@end

@implementation MSFBaseLineButton

- (void)setBaseLineColor:(UIColor *)color {
    baseLineColor = color;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGFloat descender = self.titleLabel.font.descender;
    if ([baseLineColor isKindOfClass:[UIColor class]]) {
        CGContextSetStrokeColorWithColor(contextRef, baseLineColor.CGColor);
    }
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender + 1);
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width, textRect.origin.y + textRect.size.height + descender + 1);
    
    CGContextClosePath(contextRef);
    CGContextDrawPath(contextRef, kCGPathStroke);
}

@end
