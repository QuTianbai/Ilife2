//
//	MSFRepaymentTableViewCell.m
//	Cash
//
//	Created by xutian on 15/5/17.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFRepaymentTableViewCell.h"
#import "MSFCommandView.h"

#import <Masonry/Masonry.h>
#define SEPARATORCOLOR @"5787c0"
#define CELLBACKGROUNDCOLOR @"dce6f2"
#define TYPEFACECOLOR @"5787c0"

@implementation MSFRepaymentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		_contractNum = [[UILabel alloc]init];
		_contractStatus = [[UILabel alloc]init];
		_shouldAmount = [[UILabel alloc]init];
		_asOfDate = [[UILabel alloc]init];
		_contractNumLabel = [[UILabel alloc]init];
		_contractStatusLabel = [[UILabel alloc]init];
		_shouldAmountLabel = [[UILabel alloc]init];
		_asOfDateLabel = [[UILabel alloc]init];
		
		[_contractNum setText:@"合同编号"];
		[_contractNum setTextColor:[MSFCommandView getColorWithString:TYPEFACECOLOR]];
		[_contractStatus setText:@"合同状态"];
		[_contractStatus setTextColor:[MSFCommandView getColorWithString:TYPEFACECOLOR]];
		[_shouldAmount setText:@"应还金额"];
		[_shouldAmount setTextColor:[MSFCommandView getColorWithString:TYPEFACECOLOR]];
		[_asOfDate setText:@"截止日期"];
		[_asOfDate setTextColor:[MSFCommandView getColorWithString:TYPEFACECOLOR]];
		
		//[_contractNumLabel setText:@"1231525346"];
		[_contractNumLabel setTextColor:[MSFCommandView getColorWithString:TYPEFACECOLOR]];
		//[_contractStatusLabel setText:@"已逾期"];
		[_contractStatusLabel setTextColor:[MSFCommandView getColorWithString:TYPEFACECOLOR]];
		//[_shouldAmountLabel setText:@"716.00"];
		[_shouldAmountLabel setTextColor:[MSFCommandView getColorWithString:TYPEFACECOLOR]];
		//[_asOfDateLabel setText:@"现在"];
		[_asOfDateLabel setTextColor:[MSFCommandView getColorWithString:TYPEFACECOLOR]];
		
		
		[self addSubview:_contractNum];
		[self addSubview:_contractStatus];
		[self addSubview:_shouldAmount];
		[self addSubview:_asOfDate];
		[self addSubview:_contractNumLabel];
		[self addSubview:_contractStatusLabel];
		[self addSubview:_shouldAmountLabel];
		[self addSubview:_asOfDateLabel];
		
		UIView *superView = self;
		int padding = 6;//上左下右
		/**
		 *	静态Label cellHeigth = 150
		 */
		[_contractNum mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.greaterThanOrEqualTo(superView.mas_top).offset(padding);
			make.left.equalTo(superView.mas_left).offset(4 * padding);
			make.bottom.equalTo(_contractStatus.mas_top).offset(-padding);
			make.width.equalTo(@[_contractStatus.mas_width, _shouldAmount.mas_width,_asOfDate.mas_width]);
			make.height.equalTo(@30);
			make.height.equalTo(@[_contractStatus.mas_height, _shouldAmount.mas_height, _asOfDate.mas_height,_contractStatusLabel.mas_height, _shouldAmountLabel.mas_height, _asOfDateLabel.mas_height
														, _contractNumLabel.mas_height]);
		}];
		
		[_contractStatus mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(superView.mas_left).offset(4 * padding);
			make.bottom.equalTo(_shouldAmount.mas_top).offset(-padding);
		}];
		
		[_shouldAmount mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(superView.mas_left).offset(4 * padding);
			make.bottom.equalTo(_asOfDate.mas_top).offset(-padding);
		}];
		
		[_asOfDate mas_makeConstraints:^(MASConstraintMaker *make) {
			make.left.equalTo(superView.mas_left).offset(4 * padding);
		}];
		
		/**
		 *	动态Label
		 */
		[_contractNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.greaterThanOrEqualTo(superView.mas_top).offset(padding);
			make.bottom.equalTo(_contractStatusLabel.mas_top).offset(-padding);
			make.right.equalTo(self.mas_right).offset(-7 * padding);
			make.width.equalTo(@[_contractStatusLabel.mas_width, _shouldAmountLabel.mas_width,
													 _asOfDateLabel.mas_width]);
		}];
		
		[_contractStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(_shouldAmountLabel.mas_top).offset(-padding);
			make.right.equalTo(self.mas_right).offset(-7 * padding);
		}];
		
		[_shouldAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.bottom.equalTo(_asOfDateLabel.mas_top).offset(-padding);
			make.right.equalTo(self.mas_right).offset(-7 * padding);
		}];
		
		[_asOfDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.right.equalTo(self.mas_right).offset(-7 * padding);
		}];
		
	}
	
	return self;
}

@end