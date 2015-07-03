//
// MSFPlaceholderCollectionViewCell.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFPlaceholderCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Utils.h"

@implementation MSFPlaceholderCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (!self) {
    return nil;
  }
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"progress-status-default.png"]];
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  imageView.clipsToBounds = YES;
  [self.contentView addSubview:imageView];
  [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.contentView);
  }];
  
  return self;
}

- (void)bindViewModel:(id)viewModel {
  
}

@end
