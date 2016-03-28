//
//  UINavigationBar+BackgroundColor.m
//  Finance
//
//  Created by administrator on 16/3/28.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "UINavigationBar+BackgroundColor.h"
#import <objc/runtime.h>

static char overLayKey;
static char bottomLineKey;

@implementation UINavigationBar (BackgroundColor)

- (UIView *)overLay {
    return objc_getAssociatedObject(self, &overLayKey);
}

- (void)setOverLay:(UIView *)view {
    objc_setAssociatedObject(self, &overLayKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)bottomLine {
   return  objc_getAssociatedObject(self, &bottomLineKey);
}

- (void)setBottomLine:(UIView *)line {
    objc_setAssociatedObject(self, &bottomLineKey, line, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)msf_setBackgroundColor:(UIColor *)backgroundColor {
    if (!self.overLay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overLay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + 20)];
        self.overLay.userInteractionEnabled = NO;
        self.overLay.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self insertSubview:self.overLay atIndex:0];
        self.bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 1 , CGRectGetWidth(self.bounds), 1)];
        self.bottomLine.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.bottomLine.backgroundColor = [UIColor colorWithRed:236 / 255.0f green:238 / 255.0f blue:237 / 255.0f alpha:1];
        [self addSubview:self.bottomLine];
    }
    self.overLay.backgroundColor = backgroundColor;
}

- (void)msf_reset {
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overLay removeFromSuperview];
    self.overLay = nil;
    [self.bottomLine removeFromSuperview];
    self.bottomLine = nil;
}

@end
