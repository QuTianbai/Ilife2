//
// MSFWPTextField.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFWPTextField.h"

@implementation MSFWPTextField

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
  self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder
   attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

@end
