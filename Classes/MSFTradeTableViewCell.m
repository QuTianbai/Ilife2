//
//  MSFTradeTableViewCell.m
//  Cash
//
//  Created by xutian on 15/5/17.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFTradeTableViewCell.h"
#import "MSFCommandView.h"
#import <Masonry/Masonry.h>
#define SEPARATORCOLOR @"5787c0"
#define CELLBACKGROUNDCOLOR @"dce6f2"

@interface MSFTradeTableViewCell()

@end

@implementation MSFTradeTableViewCell

- (void)awakeFromNib {
  _date = [[UILabel alloc]init];
  _amount = [[UILabel alloc]init];
  _tradeDescription = [[UILabel alloc]init];
  
  [self addSubview:_date];
  
  [self addSubview:_tradeDescription];
  
  [self addSubview:_amount];
  
  [_date mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self);
    make.left.equalTo(@10);
  }];
  
  [_tradeDescription mas_makeConstraints:^(MASConstraintMaker *make) {
    make.center.equalTo(self);
  }];
  
  [_amount mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerY.equalTo(self);
    make.right.equalTo(@-10);
  }];
}

@end
