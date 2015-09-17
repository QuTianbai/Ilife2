//
//	MSFTradeTableViewCell.m
//	Cash
//
//	Created by xutian on 15/5/17.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFTradeTableViewCell.h"
#import "MSFCommandView.h"
#import "MSFTradeViewModel.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCommandView.h"

#define BLUETCOLOR @"0babed"
#define BLACKCOLOR @"#585858"

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
	
	NSInteger edges = [UIScreen mainScreen].bounds.size.width / 6;
	
	[_date mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.centerX.equalTo(self.mas_left).offset(edges);
	}];
	
	[_tradeDescription mas_makeConstraints:^(MASConstraintMaker *make) {
		make.center.equalTo(self);
	}];
	
	[_amount mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerY.equalTo(self);
		make.centerX.equalTo(self.mas_right).offset(-edges);
	}];
	
	[self.date setTextColor:[MSFCommandView getColorWithString:BLACKCOLOR]];
	[self.tradeDescription setTextColor:[MSFCommandView getColorWithString:BLACKCOLOR]];
	[self.amount setTextColor:[MSFCommandView getColorWithString:BLACKCOLOR]];
	
	[self.date setFont:[UIFont systemFontOfSize:14]];
	[self.amount setFont:[UIFont systemFontOfSize:14]];
	[self.tradeDescription setFont:[UIFont systemFontOfSize:14]];
	[self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.03]];
}

- (void)bindViewModel:(MSFTradeViewModel *)viewModel {
	RAC(self.date, text) = RACObserve(viewModel, date);
	RAC(self.tradeDescription, text) = RACObserve(viewModel, describe);
	RAC(self.amount, text) = RACObserve(viewModel, amount);
}

@end
