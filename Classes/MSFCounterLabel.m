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
@property (nonatomic, assign) int maxTimes;

@end

@implementation MSFCounterLabel

- (void)setValueText:(NSString *)valueText {
	if ([valueText isEqualToString:@"￥_._ _"]) {
		self.text = valueText;
		return;
	}
  
	if (valueText.doubleValue == self.text.doubleValue) {
		return;
	}
  
  if ([valueText containsString:@"￥"]) {
    [valueText stringByReplacingOccurrencesOfString:@"￥" withString:@""];
  }
  _valueText = valueText;
  
  double value = valueText.doubleValue - ([self.text containsString:@"￥"] ? [self.text stringByReplacingOccurrencesOfString:@"￥" withString:@""] :self.text).doubleValue ;
	if (valueText.doubleValue == 0) {
		self.maxTimes = 15;
	} else {
		self.maxTimes = 35;
	}
	self.interval = value / self.maxTimes;
	self.animationCount = 0;
	[self change];
}

- (void)change {
	if (self.animationCount < self.maxTimes) {
		self.animationCount ++;
		double value = ([self.text containsString:@"￥"] ? [self.text stringByReplacingOccurrencesOfString:@"￥" withString:@""] :self.text).doubleValue + self.interval;
		if (value < 0) {
			value = 0.f;
		}
		self.text = [NSString stringWithFormat:@"￥%.2f", value];
	} else {
    self.text = [_valueText isEqualToString:@"0.00"] ? @"￥_._ _" :[NSString stringWithFormat:@"￥%@", _valueText];
		return;
	}
	[self performSelector:@selector(change)
						 withObject:self afterDelay:0.02 inModes:@[NSRunLoopCommonModes]];
}

@end
