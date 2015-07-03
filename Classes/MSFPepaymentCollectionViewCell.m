//
// MSFPepaymentCollectionViewCell.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFPepaymentCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "MSFLoanViewModel.h"
#import "UIColor+Utils.h"

@implementation MSFPepaymentCollectionViewCell {
  UILabel *titleLabel;
  UILabel *amountLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (!(self = [super initWithFrame:frame])) {
    return nil;
  }
  UIView *view = self.contentView;
  view.backgroundColor = UIColor.whiteColor;
  
  titleLabel = UILabel.new;
  titleLabel.textColor = UIColor.themeColor;
  titleLabel.font = [UIFont systemFontOfSize:17];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  [view addSubview:titleLabel];
  
  amountLabel = UILabel.new;
  amountLabel.textColor = UIColor.themeColor;
  amountLabel.font = [UIFont systemFontOfSize:40];
  amountLabel.textAlignment = NSTextAlignmentCenter;
  [view addSubview:amountLabel];
  
  [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@30);
    make.left.equalTo(view);
    make.right.equalTo(view);
    make.bottom.equalTo(amountLabel.mas_top).offset(-20);
  }];
  
  [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(view.mas_centerX);
    make.centerY.equalTo(view.mas_centerY).offset(20);
  }];
  
  [view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(view);
  }];
  
  [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self);
  }];
  
  UIView *line = UIView.new;
  line.backgroundColor = UIColor.themeColor;
  [self.contentView addSubview:line];
  [line mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@1);
    make.bottom.equalTo(self.contentView);
    make.left.equalTo(self.contentView);
    make.right.equalTo(self.contentView);
  }];
  
  return self;
}

- (void)bindViewModel:(MSFLoanViewModel *)viewModel {
  //TODO: 这里应该是每月的截止还款时间，这里目前使用的是申请时间用于测试显示
  titleLabel.text = [NSString stringWithFormat:@"本期截止还款日期: %@",viewModel.applyDate];
  amountLabel.text = viewModel.mothlyRepaymentAmount;
}

@end
