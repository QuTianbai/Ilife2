//
//  MSLoanListTableViewCell.m
//  Cash
//
//  Created by xbm on 15/5/20.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSLoanListTableViewCell.h"
#import <Mantle/EXTScope.h>
#import <Masonry/Masonry.h>
#import "MSFCommandView.h"
#import "MSFCellButton.h"
#define TYPEFACECOLOR @"#585858"

@implementation MSLoanListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)
reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  
  if (self) {
    _moneyLabel = [[UILabel alloc] init];
    _monthsLabel = [[UILabel alloc] init];
    _timeLabel = [[UILabel alloc] init];
    _checkLabel = [[UILabel alloc] init];
    
    _moneyLabel.textColor = [MSFCommandView getColorWithString:TYPEFACECOLOR];
    _monthsLabel.textColor = [MSFCommandView getColorWithString:TYPEFACECOLOR];
    _timeLabel.textColor = [MSFCommandView getColorWithString:TYPEFACECOLOR];
    
    _moneyLabel.font = [UIFont systemFontOfSize:13];
    _monthsLabel.font = [UIFont systemFontOfSize:13];
    _timeLabel.font = [UIFont systemFontOfSize:13];
    _checkLabel.font = [UIFont systemFontOfSize:12];
		
		_moneyLabel.textAlignment = NSTextAlignmentCenter;
    _monthsLabel.textAlignment = NSTextAlignmentCenter;
		_timeLabel.textAlignment = NSTextAlignmentCenter;
		_checkLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_moneyLabel];
    [self addSubview:_monthsLabel];
    [self addSubview:_timeLabel];
    [self addSubview:_checkLabel];
		
		CGFloat width = ([UIScreen mainScreen].bounds.size.width - 41) / 4;
		@weakify(self)
		[_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.centerY.equalTo(self);
			make.left.equalTo(self.mas_left).offset(8);
			make.width.equalTo(@(width));
		}];
		
		[_monthsLabel mas_makeConstraints:^(MASConstraintMaker *make) {\
			@strongify(self)
			make.centerY.equalTo(self);
			make.left.equalTo(self.timeLabel.mas_right);
			make.width.equalTo(@(width));
		}];

		[_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.centerY.equalTo(self);
			make.left.equalTo(self.monthsLabel.mas_right);
			make.width.equalTo(@(width));
		}];
		
    [_checkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.centerY.equalTo(self);
			make.left.equalTo(self.moneyLabel.mas_right);
			make.width.equalTo(@(width));
    }];
		
  }
  
  return self;
}

- (void)setSelectable:(BOOL)selectable {
	_selectable = selectable;
	if (selectable) {
		self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		self.selectionStyle = UITableViewCellSelectionStyleDefault;
	} else {
		self.accessoryType = UITableViewCellAccessoryNone;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
}

@end