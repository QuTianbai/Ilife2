//
//  MSLoanListTableViewCell.m
//  Cash
//
//  Created by xbm on 15/5/20.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSLoanListTableViewCell.h"
#import <Masonry/Masonry.h>
#import "MSFCommandView.h"
#import "MSFCellButton.h"
#define SEPARATORCOLOR @"5787c0"
#define CELLBACKGROUNDCOLOR @"dce6f2"
#define TYPEFACECOLOR @"#585858"

@implementation MSLoanListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)
reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (self) {
    _moneyLabel = [[UILabel alloc] init];
    _monthsLabel = [[UILabel alloc] init];
    _timeLabel = [[UILabel alloc] init];
    _checkLabel = [[UIButton alloc] init];
    
    _moneyLabel.textColor = [MSFCommandView getColorWithString:TYPEFACECOLOR];
    _monthsLabel.textColor = [MSFCommandView getColorWithString:TYPEFACECOLOR];
    _timeLabel.textColor = [MSFCommandView getColorWithString:TYPEFACECOLOR];
    _checkLabel.titleLabel.textColor = [MSFCommandView getColorWithString:TYPEFACECOLOR];
    
    
    _moneyLabel.font = [UIFont systemFontOfSize:13];
    _monthsLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _checkLabel.titleLabel.font = [UIFont systemFontOfSize:12];
    
    
    [self addSubview:_moneyLabel];
    [self addSubview:_monthsLabel];
    [self addSubview:_timeLabel];
    [self addSubview:_checkLabel];
    
    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self);
      make.left.equalTo(self.mas_left).offset(15);
      make.height.equalTo(@[_checkLabel,_monthsLabel,_timeLabel]);
    }];
    
    [_monthsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self);
      make.left.equalTo(_moneyLabel.mas_right).offset(25);
    }];

    [_checkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self);
      make.centerX.equalTo(self).offset(120);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self);
      make.left.equalTo(self.mas_centerX).offset(18);
    }];
  }
  
  return self;
}

@end