//
//  MSFSegment.m
//  Finance
//
//  Created by xbm on 15/7/22.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSegment.h"
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"

@interface MSFSegment()
{
  NSMutableArray *labelArray;
}

@end

@implementation MSFSegment
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (!(self = [super initWithCoder:aDecoder])) {
    return nil;
  }
  
  [self commonInit];
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (!(self = [super initWithFrame:frame])) {
    return nil;
  }
  [self commonInit];
  return self;
}

- (void)commonInit {
  labelArray = [[NSMutableArray alloc] init];
  self.layer.borderWidth = 2;
  self.layer.borderColor = [UIColor whiteColor].CGColor;
  self.momentary = YES;
  NSArray *array = self.subviews;
  for (UIView *view in array) {
    NSUInteger i = [array indexOfObject:view];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-3, view.frame.size.width, 2)];
    label.tag =self.numberOfSegments-1-i;
    if (label.tag == 0) {
      label.hidden = NO;
    } else {
      label.hidden = YES;
    }
    [labelArray addObject:label];
    label.backgroundColor = [MSFCommandView getColorWithString:POINTWHITECOLR];
    [view addSubview:label];
  }
}

- (void)setLineColors {
  if ([self.delegate respondsToSelector:@selector(setLineColor:)]) {
    [self.delegate setLineColor:labelArray];
  }
}

@end
