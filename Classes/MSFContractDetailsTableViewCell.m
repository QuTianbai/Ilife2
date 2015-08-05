//
//	MSFContractDetailsTableViewCell.m
//	Cash
//
//	Created by xutian on 15/5/18.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFContractDetailsTableViewCell.h"
#import <Masonry/Masonry.h>
#import "MSFCommandView.h"

#define BLUETCOLOR @"0babed"

@implementation MSFContractDetailsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		_asOfDateLabel = [[UILabel alloc]init];
		_shouldAmountLabel = [[UILabel alloc]init];
		_paymentLabel = [[UILabel alloc]init];
		_stateLabel = [[UILabel alloc]init];
		
		_asOfDateLabel.textColor = [MSFCommandView getColorWithString:BLUETCOLOR];
		_shouldAmountLabel.textColor = [MSFCommandView getColorWithString:BLUETCOLOR];
		_paymentLabel.textColor = [MSFCommandView getColorWithString:BLUETCOLOR];
		_stateLabel.textColor = [MSFCommandView getColorWithString:BLUETCOLOR];
		
		[self addSubview:_asOfDateLabel];
		[self addSubview:_shouldAmountLabel];
		[self addSubview:_paymentLabel];
		[self addSubview:_stateLabel];
		
		[_shouldAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.right.equalTo(self.mas_centerX).offset(20);
		}];
		
		[_paymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self.mas_centerX).offset(4);
		}];
		
		[_asOfDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.left.equalTo(self).offset(8);
			make.width.equalTo(@90);
			make.width.equalTo(@[_shouldAmountLabel, _paymentLabel,_stateLabel]);
			make.height.equalTo(@30);
			make.height.equalTo(@[_shouldAmountLabel, _paymentLabel,_stateLabel]);
		}];
		
		[_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.right.equalTo(self.mas_right).offset(-8);
		}];
	}
	
	return self;
}

@end