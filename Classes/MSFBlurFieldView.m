//
// MSFBlurFieldView.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFBlurFieldView.h"

@implementation MSFBlurFieldView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (!(self = [super initWithCoder:aDecoder])) {
    return nil;
  }
  self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.200];
  
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (!(self = [super initWithFrame:frame])) {
    return nil;
  }
  self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.200];
  
  return self;
}

@end
