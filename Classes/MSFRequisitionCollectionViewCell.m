//
// MSFRequisitionCollectionViewCell.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFRequisitionCollectionViewCell.h"
#import "UIColor+Utils.h"
#import <Masonry/Masonry.h>
#import "MSFLoanViewModel.h"

NSString *(^CNY)(NSString *) = ^(NSString *string) {
  return [NSString stringWithFormat:@"¥ %@",string];
};

@interface MSFCycleView : UIView

@end

@implementation MSFCycleView

- (void)drawRect:(CGRect)rect {
  UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, 40, 40)];
  [UIColor.themeColor setStroke];
  ovalPath.lineWidth = 1;
  [ovalPath stroke];
}

@end

@implementation MSFRequisitionCollectionViewCell {
  UILabel *titleLabel;
  UILabel *dateLabel;
  UILabel *amountLabel;
  UILabel *monthLabel;
  UILabel *statusLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
  if (!(self = [super initWithFrame:frame])) {
    return nil;
  }
  UIView *view = self.contentView;
  view.backgroundColor = UIColor.whiteColor;
  
  titleLabel = UILabel.new;
  titleLabel.textColor = UIColor.themeColor;
  titleLabel.font = [UIFont boldSystemFontOfSize:17];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  [view addSubview:titleLabel];
  
  UIView *leftView = UIView.new;
  [view addSubview:leftView];
  
  dateLabel = UILabel.new;
  dateLabel.textColor = UIColor.themeColor;
  dateLabel.font = [UIFont systemFontOfSize:14];
  dateLabel.textAlignment = NSTextAlignmentCenter;
  [leftView addSubview:dateLabel];
  
  amountLabel = UILabel.new;
  amountLabel.textColor = UIColor.themeColor;
  amountLabel.font = [UIFont systemFontOfSize:18];
  amountLabel.textAlignment = NSTextAlignmentCenter;
  [leftView addSubview:amountLabel];
  
  monthLabel = UILabel.new;
  monthLabel.textColor = UIColor.themeColor;
  monthLabel.font = [UIFont systemFontOfSize:18];
  monthLabel.textAlignment = NSTextAlignmentCenter;
  [leftView addSubview:monthLabel];
  
  [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.height.equalTo(@20);
    make.centerX.equalTo(leftView.mas_centerX);
  }];
  [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(dateLabel.mas_bottom).offset(10);
    make.height.equalTo(@20);
    make.centerX.equalTo(leftView.mas_centerX);
    make.centerY.equalTo(leftView.mas_centerY);
  }];
  [monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(amountLabel.mas_bottom);
    make.height.equalTo(@20);
    make.centerX.equalTo(leftView.mas_centerX);
  }];
  
  UIView *rightView = UIView.new;
  [view addSubview:rightView];
  MSFCycleView *cycleView = MSFCycleView.new;
  cycleView.backgroundColor = UIColor.whiteColor;
  [rightView addSubview:cycleView];
  
  statusLabel = UILabel.new;
  statusLabel.textColor = UIColor.themeColor;
  statusLabel.font = [UIFont systemFontOfSize:15];
  statusLabel.textAlignment = NSTextAlignmentCenter;
  [rightView addSubview:statusLabel];
  
  [cycleView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(rightView);
    make.width.equalTo(rightView.mas_height);
    make.height.equalTo(rightView.mas_height);
  }];
  
  [statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(rightView);
    make.width.equalTo(rightView.mas_height);
    make.height.equalTo(rightView.mas_height);
  }];
  
  [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(titleLabel.mas_bottom);
    make.bottom.equalTo(view);
    make.left.equalTo(view).offset(20);
    make.right.equalTo(rightView.mas_left);
    make.width.equalTo(rightView.mas_width);
  }];
  
  [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(titleLabel.mas_bottom);
    make.bottom.equalTo(view.mas_bottom);
    make.right.equalTo(view.mas_right).offset(-20);
    make.left.equalTo(leftView.mas_right);
    make.width.equalTo(leftView.mas_width);
  }];
  
  [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(view).offset(10);
    make.height.equalTo(@30);
    make.centerX.equalTo(view);
  }];
  
  [view mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.contentView);
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
  titleLabel.text = viewModel.title;
  dateLabel.text = viewModel.applyDate;
  amountLabel.text = viewModel.totalAmount;
  monthLabel.text = viewModel.mothlyRepaymentAmount;
  statusLabel.text = viewModel.status;
}

@end
