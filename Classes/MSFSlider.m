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
//
//- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//	NSLog(@"slder1");
//	//[self sliderGragUp:self];
//}

- (void)customSlider {
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, 80, 20)];
  titleLabel.font = [UIFont systemFontOfSize:15];
  titleLabel.text = @"贷款金额";
  titleLabel.textColor = [UIColor blackColor];
  [self addSubview:titleLabel];
  
  self.moneyNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, -20, 100, 20)];
  self.moneyNumLabel.textColor = [UIColor blackColor];
  self.moneyNumLabel.textAlignment = NSTextAlignmentLeft;
  //self.moneyNumLabel.text = @"0元";
  RAC(self.moneyNumLabel, text) = [RACObserve(self, minimumValue) map:^id(NSString *value) {
    if (!value) {
      return [NSString stringWithFormat:@"0.00元"];
    }
		[self sliderGragUp:self];
    return [NSString stringWithFormat:@"%@元", value];
  }];
  [self addSubview:self.moneyNumLabel];
  
  [self setMinimumTrackImage:[UIImage imageNamed:@"bar-highlighted"] forState:UIControlStateNormal];
  [self setMaximumTrackImage:[UIImage imageNamed:@"1242-2208-灰色"] forState:UIControlStateNormal];
  UIImage *thumbImage = [UIImage imageNamed:@"btnSlider"];
  [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
  
  [self setThumbImage:thumbImage forState:UIControlStateNormal];
  
  [self addTarget:self action:@selector(slideerValueChanged:) forControlEvents:UIControlEventValueChanged];
  [self addTarget:self action:@selector(sliderGragUp:) forControlEvents:UIControlEventTouchUpOutside];
	[self addTarget:self action:@selector(sliderGragUp:) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)slideerValueChanged:(UISlider *)slider {
	self.moneyNumLabel.text = [NSString stringWithFormat:@"%d元", slider.value < 100? (int)slider.minimumValue : (int)slider.value / 100 * 100];
}

- (void)sliderGragUp:(UISlider *)slider {
	NSLog(@"slider3");
  if ([self.delegate respondsToSelector:@selector(getStringValue:)]) {
    [self.delegate getStringValue:[NSString stringWithFormat:@"%d", slider.value < 100? (int)slider.minimumValue : (int)slider.value / 100 * 100]];
  }
}

@end
