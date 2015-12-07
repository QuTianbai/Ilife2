//
//  MSFHomePageContentView.m
//  Finance
//
//  Created by 赵勇 on 11/28/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFHomePageContentView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Masonry/Masonry.h>

#import "UIColor+Utils.h"
#import "UILabel+AttributeColor.h"

#import "MSFHomePageCellModel.h"

@interface MSFHomePageContentView ()

@end

@implementation MSFHomePageContentView

- (instancetype)init {
	self = [super init];
	if (self) {
		
		UILabel *title = [[UILabel alloc] init];
		title.font = [UIFont boldSystemFontOfSize:20];
		title.textColor = UIColor.themeColorNew;
		title.tag = 100;
		
		UIButton *status = [UIButton buttonWithType:UIButtonTypeCustom];
		status.layer.cornerRadius = 5;
		status.layer.borderColor = UIColor.themeColorNew.CGColor;
		status.layer.borderWidth = 1;
		status.titleLabel.font = [UIFont systemFontOfSize:15];
		[status setTitleColor:UIColor.themeColorNew forState:UIControlStateNormal];
		status.tag = 101;
		_statusSignal = [status rac_signalForControlEvents:UIControlEventTouchUpInside];
		
		UILabel *unit = [[UILabel alloc] init];
		unit.font = [UIFont boldSystemFontOfSize:25];
		unit.textColor = UIColor.themeColorNew;
		unit.text = @"￥";
		unit.tag = 102;
		
		UILabel *amount = [[UILabel alloc] init];
		amount.font = [UIFont boldSystemFontOfSize:40];
		amount.textColor = UIColor.themeColorNew;
		amount.tag = 103;
		
		UILabel *info = [[UILabel alloc] init];
		info.font = [UIFont systemFontOfSize:14];
		info.textColor = UIColor.lightGrayColor;
		info.textAlignment = NSTextAlignmentCenter;
		info.numberOfLines = 0;
		info.tag = 104;
				
		[self addSubview:title];
		[self addSubview:status];
		[self addSubview:unit];
		[self addSubview:amount];
		[self addSubview:info];
		
		[amount mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.centerY.equalTo(self).offset(15);
		}];
		[unit mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self).offset(16);
			make.right.equalTo(amount.mas_left);
		}];
		[status mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.bottom.equalTo(amount.mas_top).offset(-15);
			make.width.equalTo(@80);
			make.height.equalTo(@25);
		}];
		[title mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.bottom.equalTo(status.mas_top).offset(-20);
		}];
		[info mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerX.equalTo(self);
			make.left.equalTo(self).offset(8);
			make.right.equalTo(self).offset(-8);
			make.top.equalTo(amount.mas_bottom).offset(20);
		}];
	}
	return self;
}

- (void)updateWithModel:(MSFHomePageCellModel *)model {
	UILabel *title   = (UILabel *)[self viewWithTag:100];
	UIButton *status = (UIButton *)[self viewWithTag:101];
	UILabel *unit    = (UILabel *)[self viewWithTag:102];
	UILabel *amount  = (UILabel *)[self viewWithTag:103];
	UILabel *info    = (UILabel *)[self viewWithTag:104];
	
	title.text  = model.title;
	[status setTitle:model.statusString forState:UIControlStateNormal];
	
	switch (model.dateDisplay) {
		case MSFHomePageDateDisplayTypeApply:
			amount.text = model.money;
			unit.hidden = NO;
			info.text = [NSString stringWithFormat:@"%@   |   %@个月", model.applyTime, model.loanTerm];
			break;
		case MSFHomePageDateDisplayTypeRepay:
			amount.text = model.money;
			unit.hidden = NO;
			info.text = [NSString stringWithFormat:@"本期还款截止日期\n%@", model.currentPeriodDate];
			break;
		case MSFHomePageDateDisplayTypeOverDue:
			amount.text = model.money;
			unit.hidden = NO;
			[info setText:@"你的合同已逾期\n请及时联系客服还款：400-036-8876" highLightText:@"已逾期" highLightColor:UIColor.tintColor];
			break;
		case MSFHomePageDateDisplayTypeProcessing:
			amount.text = nil;
			unit.hidden = YES;
			info.text = @"合同正在处理中";
			break;
		case MSFHomePageDateDisplayTypeNone:
			amount.text = nil;
			unit.hidden = YES;
			info.text = nil;
			break;
	}
}

@end
