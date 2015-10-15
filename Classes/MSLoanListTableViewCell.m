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
		
		@weakify(self)
		[_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.centerY.equalTo(self);
			make.left.equalTo(self);
		}];
		
		[_monthsLabel mas_makeConstraints:^(MASConstraintMaker *make) {\
			@strongify(self)
			make.centerY.equalTo(self);
			make.left.equalTo(self.timeLabel.mas_right);
		}];
		
		[_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.centerY.equalTo(self);
			make.left.equalTo(self.monthsLabel.mas_right);
		}];
		
		[_checkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.centerY.equalTo(self);
			make.left.equalTo(self.moneyLabel.mas_right);
			make.right.equalTo(self);
			make.width.equalTo(@[_timeLabel, _monthsLabel, _moneyLabel]);
		}];
	}
	
	return self;
}

- (void)bindModel:(MSFApplyList *)model {
	_moneyLabel.text = model.total_amount;
	_monthsLabel.text = [NSString stringWithFormat:@"%@期", model.total_installments];
	_timeLabel.text = model.apply_time;
	_checkLabel.text = model.statusString;
	/*
	if ([model.statusString isEqualToString:@"还款中"] || [model.statusString isEqualToString:@"已完结"] || [model.statusString isEqualToString:@"已逾期"]) {
		self.selectable = YES;
		//self.checkLabel.textColor = [MSFCommandView getColorWithString:[UIColor orangeColor]];
	} else {
		self.selectable = NO;
		//self.checkLabel.textColor = [MSFCommandView getColorWithString:TYPEFACECOLOR];
	}*/
}
/*
- (void)setSelectable:(BOOL)selectable {
	_selectable = selectable;
	if (selectable) {
		self.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
		self.selectionStyle = UITableViewCellSelectionStyleDefault;
	} else {
		self.accessoryType  = UITableViewCellAccessoryNone;
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
}*/

@end