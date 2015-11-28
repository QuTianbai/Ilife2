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

- (void)dealloc {
	
}

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
		_checkLabel.textColor = [MSFCommandView getColorWithString:TYPEFACECOLOR];
		
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
		
		[_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self);
		}];
		
		[_monthsLabel mas_makeConstraints:^(MASConstraintMaker *make) {\
			make.centerY.equalTo(self);
			make.left.equalTo(self.timeLabel.mas_right);
		}];
		
		[_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self.monthsLabel.mas_right);
		}];
		
		[_checkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self.moneyLabel.mas_right);
			make.right.equalTo(self);
			make.width.equalTo(@[_timeLabel, _monthsLabel, _moneyLabel]);
		}];
	}
	
	return self;
}

- (void)bindModel:(MSFApplyList *)model type:(int)type {
	if (type == 1) {
		[_moneyLabel removeFromSuperview];
		[_monthsLabel removeFromSuperview];
		[_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self);
		}];
		[_checkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(_timeLabel.mas_right);
			make.right.equalTo(self);
			make.width.equalTo(_timeLabel);
		}];
	} else {
		[self addSubview:_moneyLabel];
		[self addSubview:_monthsLabel];
		[_timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self);
		}];
		[_monthsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {\
			make.centerY.equalTo(self);
			make.left.equalTo(self.timeLabel.mas_right);
		}];
		[_moneyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self.monthsLabel.mas_right);
		}];
		[_checkLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self.moneyLabel.mas_right);
			make.right.equalTo(self);
			make.width.equalTo(@[_timeLabel, _monthsLabel, _moneyLabel]);
		}];
		_moneyLabel.text = model.appLmt;
		_monthsLabel.text = [NSString stringWithFormat:@"%@期", model.loanTerm];
	}
	_timeLabel.text = model.applyTime;
	_checkLabel.text = model.statusString;
}

@end