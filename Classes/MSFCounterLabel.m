//
//  MSFCounterLabel.m
//  Finance
//
//  Created by 赵勇 on 7/31/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "MSFCounterLabel.h"

@interface MSFCounterLabel ()

@property (nonatomic, assign) double interval;
@property (nonatomic, assign) int animationCount;

@end

@implementation MSFCounterLabel

- (void)setValueText:(NSString *)valueText {
	_valueText = valueText;
	if ([valueText isEqualToString:@"未知"]) {
		self.text = valueText;
		return;
	}
	double value = valueText.doubleValue - self.text.doubleValue;
	self.interval = value / 35;
	self.animationCount = 0;
	[self change];
}

- (void)change {
	if (self.animationCount < 35) {
		self.animationCount ++;
		double value = self.text.doubleValue + self.interval;
		self.text = [NSString stringWithFormat:@"%.2f", value];
	} else {
		self.text = _valueText;
		return;
	}
	[self performSelector:@selector(change)
						 withObject:self afterDelay:0.02 inModes:@[NSRunLoopCommonModes]];
}

@end
