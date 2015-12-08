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

@implementation MSFContractDetailsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		_asOfDateLabel = [[UILabel alloc] init];
		_shouldAmountLabel = [[UILabel alloc] init];
		_paymentLabel = [[UILabel alloc] init];
		_stateLabel = [[UILabel alloc] init];
		
		_asOfDateLabel.font = [UIFont systemFontOfSize:13];
		_shouldAmountLabel.font = [UIFont systemFontOfSize:13];
		_paymentLabel.font = [UIFont systemFontOfSize:13];
		_stateLabel.font = [UIFont systemFontOfSize:13];
		
		
		[self addSubview:_asOfDateLabel];
		[self addSubview:_shouldAmountLabel];
		[self addSubview:_paymentLabel];
		[self addSubview:_stateLabel];
		
		NSInteger edges = [UIScreen mainScreen].bounds.size.width / 8;
		[_asOfDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.centerX.equalTo(self.mas_left).offset(edges);
			make.height.equalTo(@[_shouldAmountLabel, _paymentLabel,_stateLabel]);
		}];
		
		[_shouldAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.centerX.equalTo(self.mas_centerX).offset(-edges);
		}];
		
		[_paymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.centerX.equalTo(self.mas_centerX).offset(edges);
		}];
		
		[_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			make.centerY.equalTo(self);
			make.centerX.equalTo(self.mas_right).offset(-edges);
		}];
	}
	
	return self;
}

@end