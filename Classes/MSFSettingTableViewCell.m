//
//  MSFSettingTableViewCell.m
//  Cash
//
//  Created by xutian on 15/6/5.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSettingTableViewCell.h"
#import "MSFCommandView.h"
#import <Masonry/Masonry.h>

#define SEPARATORCOLOR @"5787c0"
#define CELLBACKGROUNDCOLOR @"dce6f2"
#define TYPEFACECOLOR @"5787c0"

@implementation MSFSettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    _picImageView = [[UIImageView alloc]init];
    _text_label = [[UILabel alloc]init];
    
    [self addSubview:self.picImageView];
    [self addSubview:self.text_label];
    
    [_picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self);
      make.left.equalTo(self.mas_left).offset(20);
      make.height.equalTo(@[_text_label]);
    }];
    
    [_text_label mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerY.equalTo(self);
      make.left.equalTo(_picImageView.mas_right).offset(30);
    }];
  }
  
  return self;
}

@end
