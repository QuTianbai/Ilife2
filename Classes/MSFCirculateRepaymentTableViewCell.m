
//
//  MSFCirculateRepaymentTableViewCell.m
//  Finance
//
//  Created by xbm on 15/11/18.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFCirculateRepaymentTableViewCell.h"
#import <Mantle/EXTScope.h>
#import <Masonry/Masonry.h>
#import "MSFRepaymentSchedulesViewModel.h"
#import "MSFCommandView.h"

#define REPAY_DARK_COLOR  @"464646"
#define REPAY_LIGHT_COLOR @"878787"
#define REPAY_BORDER_COLOR @"DADADA"

@interface MSFCirculateRepaymentTableViewCell()

/** UI **/
//@property (strong, nonatomic) UILabel *contractNum;//合同编号

@property (strong, nonatomic) UILabel *contractStatus;//合同状态
@property (strong, nonatomic) UILabel *shouldAmount;//最近应还金额
@property (strong, nonatomic) UILabel *asOfDate;//最近应还日期
@property (strong, nonatomic) UILabel *ownerAllMoney;//总欠款金额
@property (strong, nonatomic) UILabel *contractLineDate;//合同到期日期

@property (strong, nonatomic) UILabel *contractStatusLabel;//合同状态value
@property (strong, nonatomic) UILabel *shouldAmountLabel;//应还金额value
@property (strong, nonatomic) UILabel *asOfDateLabel;//截止日期Label
@property (strong, nonatomic) UILabel *ownerAllMoneyVlaue;//总欠款金额value
@property (strong, nonatomic) UILabel *contractLineDateValue;//合同到期日期value

//UI参数
@property (assign, nonatomic) CGFloat topMargin;
@property (assign, nonatomic) CGFloat padding;
@property (assign, nonatomic) CGFloat topHeight;
@property (assign, nonatomic) CGFloat labelHeight;
@property (assign, nonatomic) CGFloat topLineGuide;

@end

@implementation MSFCirculateRepaymentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		_topMargin = 13.f;
		_padding = 8.f;
		_topHeight = 40;
		_labelHeight = 30.f;
		_topLineGuide = _topHeight + _topMargin;
		
		//_contractNum				 = [[UILabel alloc]init];
		_contractStatus			 = [[UILabel alloc]init];
		_shouldAmount				 = [[UILabel alloc]init];
		_asOfDate						 = [[UILabel alloc]init];
		_contractStatusLabel = [[UILabel alloc]init];
		_shouldAmountLabel	 = [[UILabel alloc]init];
		_asOfDateLabel			 = [[UILabel alloc]init];
		_ownerAllMoney       = [[UILabel alloc] init];
		_ownerAllMoneyVlaue  = [[UILabel alloc] init];
		_contractLineDate    = [[UILabel alloc] init];
		_contractLineDateValue = [[UILabel alloc] init];
		
		//[_contractNum setTextColor:[MSFCommandView getColorWithString:REPAY_DARK_COLOR]];
		//_contractNum.font = [UIFont systemFontOfSize:15];
		
		[_contractStatus setText:@"合同状态"];
		[_contractStatus setTextColor:[MSFCommandView getColorWithString:REPAY_LIGHT_COLOR]];
		_contractStatus.font = [UIFont systemFontOfSize:13];
		_contractStatus.textAlignment = NSTextAlignmentRight;
		
		[_shouldAmount setText:@"最近应还金额"];
		[_shouldAmount setTextColor:[MSFCommandView getColorWithString:REPAY_LIGHT_COLOR]];
		_shouldAmount.font = [UIFont systemFontOfSize:13];
		_shouldAmount.textAlignment = NSTextAlignmentCenter;
		
		[_asOfDate setText:@"最近还款日期"];
		[_asOfDate setTextColor:[MSFCommandView getColorWithString:REPAY_LIGHT_COLOR]];
		_asOfDate.font = [UIFont systemFontOfSize:13];
		_asOfDate.textAlignment = NSTextAlignmentCenter;
		
		[_ownerAllMoney setText:@"总欠款金额"];
		[_ownerAllMoney setTextColor:[MSFCommandView getColorWithString:REPAY_LIGHT_COLOR]];
		_ownerAllMoney.font = [UIFont systemFontOfSize:13];
		_ownerAllMoney.textAlignment = NSTextAlignmentCenter;
		
		[_contractLineDate setText:@"合同截止日期"];
		[_contractLineDate setTextColor:[MSFCommandView getColorWithString:REPAY_LIGHT_COLOR]];
		_contractLineDate.font = [UIFont systemFontOfSize:13];
		_contractLineDate.textAlignment = NSTextAlignmentCenter;
		
		
		
		[_contractStatusLabel setTextColor:[MSFCommandView getColorWithString:REPAY_DARK_COLOR]];
		_contractStatusLabel.font = [UIFont systemFontOfSize:13];
		_contractStatusLabel.textAlignment = NSTextAlignmentCenter;
		[_shouldAmountLabel setTextColor:[MSFCommandView getColorWithString:REPAY_DARK_COLOR]];
		_shouldAmountLabel.font = [UIFont systemFontOfSize:13];
		_shouldAmountLabel.textAlignment = NSTextAlignmentCenter;
		[_asOfDateLabel setTextColor:[MSFCommandView getColorWithString:REPAY_DARK_COLOR]];
		_asOfDateLabel.font = [UIFont systemFontOfSize:13];
		_asOfDateLabel.textAlignment = NSTextAlignmentCenter;
		[_ownerAllMoneyVlaue setTextColor:[MSFCommandView getColorWithString:REPAY_DARK_COLOR]];
		_ownerAllMoneyVlaue.font = [UIFont systemFontOfSize:13];
		_ownerAllMoneyVlaue.textAlignment = NSTextAlignmentCenter;
		[_contractLineDateValue setTextColor:[MSFCommandView getColorWithString:REPAY_DARK_COLOR]];
		_contractLineDateValue.font = [UIFont systemFontOfSize:13];
		_contractLineDateValue.textAlignment = NSTextAlignmentCenter;
		
		
		//[self addSubview:_contractNum];
		[self addSubview:_contractStatus];
		[self addSubview:_shouldAmount];
		[self addSubview:_asOfDate];
		[self addSubview:_contractStatusLabel];
		[self addSubview:_shouldAmountLabel];
		[self addSubview:_asOfDateLabel];
		[self addSubview:_ownerAllMoney];
		[self addSubview:_ownerAllMoneyVlaue];
		[self addSubview:_contractLineDate];
		[self addSubview:_contractLineDateValue];
		@weakify(self)
//		[_contractNum mas_makeConstraints:^(MASConstraintMaker *make) {
//			@strongify(self)
//			make.left.equalTo(self).offset(self.padding);
//			make.right.equalTo(self).offset(self.padding);
//			make.top.equalTo(self).offset(self.topMargin);
//			make.height.equalTo(@(self.topHeight));
//		}];
//		[_contractStatus mas_makeConstraints:^(MASConstraintMaker *make) {
//			@strongify(self)
//			make.top.equalTo(self).offset(_topLineGuide);
//			make.left.equalTo(self);
//			make.height.equalTo(@(self.labelHeight));
//		}];
		[_contractStatus mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self).offset(self.topMargin);
			make.left.equalTo(self).offset(self.padding);
			make.right.equalTo(self).offset(-self.padding);
			make.height.equalTo(@(self.topHeight));
		}];
//		[_shouldAmount mas_makeConstraints:^(MASConstraintMaker *make) {
//			@strongify(self)
//			make.top.equalTo(self).offset(_topLineGuide);
//			make.left.equalTo(self.contractStatus.mas_right);
//			make.height.equalTo(@(self.labelHeight));
//		}];
		[_shouldAmount mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self).offset(_topLineGuide);
			make.left.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
		}];

//		[_asOfDate mas_makeConstraints:^(MASConstraintMaker *make) {
//			@strongify(self)
//			make.top.equalTo(self).offset(_topLineGuide);
//			make.left.equalTo(self.shouldAmount.mas_right);
//			make.right.equalTo(self);
//			make.height.equalTo(@(self.labelHeight));
//			make.width.equalTo(@[_contractStatus, _shouldAmount]);
//		}];
		[_asOfDate mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self).offset(_topLineGuide);
			make.left.equalTo(self.shouldAmount.mas_right);
			make.right.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
			make.width.equalTo(@[_shouldAmount]);
		}];

//		[_contractStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//			@strongify(self)
//			make.top.equalTo(self.contractStatus.mas_bottom);
//			make.left.equalTo(self);
//			make.height.equalTo(@(self.labelHeight));
//		}];
//		[_contractStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//			@strongify(self)
//			make.top.equalTo(self.contractStatus.mas_bottom);
//			make.left.equalTo(self);
//			make.height.equalTo(@(self.labelHeight));
//		}];

//		[_shouldAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//			@strongify(self)
//			make.top.equalTo(self.shouldAmount.mas_bottom);
//			make.left.equalTo(self.contractStatusLabel.mas_right);
//			make.height.equalTo(@(self.labelHeight));
//		}];
		[_shouldAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self.shouldAmount.mas_bottom);
			make.left.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
		}];

		[_asOfDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self.asOfDate.mas_bottom);
			make.left.equalTo(self.shouldAmountLabel.mas_right);
			make.right.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
			make.width.equalTo(@[_shouldAmountLabel]);
		}];
		
		[_ownerAllMoney mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self.shouldAmountLabel.mas_bottom);
			make.left.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
		}];
		[_ownerAllMoneyVlaue mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self.ownerAllMoney.mas_bottom);
			make.left.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
		}];
		[_contractLineDate mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self.asOfDateLabel.mas_bottom);
			make.left.equalTo(self.ownerAllMoney.mas_right);
			make.right.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
			make.width.equalTo(@[_ownerAllMoney]);
		}];
		[_contractLineDateValue mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self.contractLineDate.mas_bottom);
			make.left.equalTo(self.ownerAllMoneyVlaue.mas_right);
			make.right.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
			make.width.equalTo(@[_ownerAllMoneyVlaue]);
		}];
		
	}
	
	return self;
}

- (void)bindViewModel:(MSFRepaymentSchedulesViewModel *)viewModel {
	//_contractNum.text = [NSString stringWithFormat:@"合同编号    %@", viewModel.repaymentNumber];
	_contractStatusLabel.text = viewModel.status;
	_shouldAmountLabel.text = [NSString stringWithFormat:@"%.2f", viewModel.amount];
	_asOfDateLabel.text = viewModel.date;

	_ownerAllMoneyVlaue.text = viewModel.ownerAllMoney;
	_contractLineDateValue.text = viewModel.contractLineDate;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[[MSFCommandView getColorWithString:REPAY_BORDER_COLOR] setStroke];
	CGContextSetLineWidth(context, 0.5);
	
	CGContextMoveToPoint(context, 0, _topMargin + 0.5);
	CGContextAddLineToPoint(context, rect.size.width, _topMargin + 0.5);
	
	CGContextMoveToPoint(context, 0, rect.size.height - 0.5);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 0.5);
	
	CGContextMoveToPoint(context, rect.size.width / 2, self.topLineGuide);
	CGContextAddLineToPoint(context, rect.size.width / 2, rect.size.height - self.padding);
	
//	CGContextMoveToPoint(context, rect.size.width * 2 / 3, self.topLineGuide);
//	CGContextAddLineToPoint(context, rect.size.width * 2 / 3, rect.size.height - self.padding);
	
	CGContextStrokePath(context);
}

@end
