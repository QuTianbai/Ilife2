//
//  MSLoanListTableViewCell.m
//  Cash
//
//  Created by xbm on 15/5/20.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSLoanListTableViewCell.h"
#import <libextobjc/extobjc.h>
#import <Masonry/Masonry.h>

#import "MSFCommandView.h"
#import "MSFCellButton.h"
#import "MSFApplyList.h"

#import "NSDateFormatter+MSFFormattingAdditions.h"

#define TYPEFACECOLOR @"#585858"

@interface MSLoanListTableViewCell ()

@property (strong, nonatomic) UILabel *moneyLabel;
@property (strong, nonatomic) UILabel *monthsLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *checkLabel;
@property (assign, nonatomic) BOOL selectable;

@end

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

- (void)bindModel:(MSFApplyList *)model {

	_moneyLabel.text = model.total_amount;
	_monthsLabel.text = [NSString stringWithFormat:@"%@期", model.total_installments];
	_timeLabel.text = model.apply_time;
	/*
	if (model.status.integerValue == 4 || listModel.status.integerValue == 6 || listModel.status.integerValue == 7) {
		cell.selectable = YES;
		cell.checkLabel.textColor = [MSFCommandView getColorWithString:ORAGECOLOR];
	} else {
		cell.selectable = NO;
		cell.checkLabel.textColor = [MSFCommandView getColorWithString:@"#585858"];
	}*/
	
	_checkLabel.text = @"状态";//[self getStatus:listModel.status.integerValue];

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