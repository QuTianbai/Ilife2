//
//  MSFSlider.m
//  MSFSlider
//
//  Created by xbm on 15/7/27.
//  Copyright (c) 2015年 xbm. All rights reserved.
//

#import "MSFSlider.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFSlider ()

@end

@implementation MSFSlider

- (instancetype)initWithFrame:(CGRect)frame {
  if (!(self = [super initWithFrame:frame])) {
    return nil;
  }
  
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (!(self = [super initWithCoder:aDecoder])) {
    return nil;
  }
  [self customSlider];
  return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
	if ([self.delegate respondsToSelector:@selector(startSliding)]) {
		NSLog(@"slder");
		[self.delegate startSliding];
	}
	
	return YES;
}

- (void)customSlider {
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, 120, 20)];
  titleLabel.font = [UIFont systemFontOfSize:15];
  titleLabel.text = @"贷款金额";
  titleLabel.textColor = [UIColor blackColor];
  [self addSubview:titleLabel];
	self.titleLabel = titleLabel;
  
  self.moneyNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, -20, 200, 20)];
  self.moneyNumLabel.textColor = [UIColor blackColor];
  self.moneyNumLabel.textAlignment = NSTextAlignmentLeft;
  [self addSubview:self.moneyNumLabel];
	
	@weakify(self)
  RAC(self.moneyNumLabel, text) = [RACObserve(self, value) map:^id(NSNumber *value) {
		@strongify(self)
		return [NSString stringWithFormat:@"%ld元", value.floatValue < 100 ? (long)self.minimumValue : (long)value.integerValue];
  }];
	[RACObserve(self, minimumValue) subscribeNext:^(id x) {
		@strongify(self)
		self.value = [x floatValue];
		[self sliderGragUp:self];
	}];
	
	RAC(self, titleLabel.text) = [RACObserve(self, hiddenAmount) map:^id(id value) {
		return [value boolValue] ? @"贷款金额（元）" : @"贷款金额";
	}];
	RAC(self, moneyNumLabel.hidden) = RACObserve(self, hiddenAmount);
	
	self.minimumTrackTintColor = [UIColor colorWithRed:0.086 green:0.600 blue:0.898 alpha:1.000];
  [self setMaximumTrackImage:[UIImage imageNamed:@"1242-2208-灰色"] forState:UIControlStateNormal];
  UIImage *thumbImage = [UIImage imageNamed:@"btnSlider"];
  [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
  
  [self setThumbImage:thumbImage forState:UIControlStateNormal];
  
  [self addTarget:self action:@selector(slideerValueChanged:) forControlEvents:UIControlEventValueChanged];
  [self addTarget:self action:@selector(sliderGragUp:) forControlEvents:UIControlEventTouchUpOutside];
	[self addTarget:self action:@selector(sliderGragUp:) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)slideerValueChanged:(UISlider *)slider {
	if (self.hiddenAmount) return;
	self.moneyNumLabel.text = [NSString stringWithFormat:@"%d元", slider.value == slider.minimumValue? (int)slider.minimumValue : ((int)slider.value / 500 + 1) * 500];
}

- (void)sliderGragUp:(UISlider *)slider {
	// 手指移开slider时获取的金额
  if ([self.delegate respondsToSelector:@selector(getStringValue:)]) {
    [self.delegate getStringValue:[NSString stringWithFormat:@"%d", slider.value == slider.minimumValue? (int)slider.minimumValue : ((int)slider.value / 500 + 1) * 500]];
  }
}

@end
