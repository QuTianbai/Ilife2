//
//	MSFRepaymentTableViewCell.m
//	Cash
//
//	Created by xutian on 15/5/17.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFRepaymentTableViewCell.h"
#import <libextobjc/extobjc.h>
#import <Masonry/Masonry.h>
#import "MSFRepaymentSchedulesViewModel.h"
#import "MSFCommandView.h"

#define REPAY_DARK_COLOR  @"464646"
#define REPAY_LIGHT_COLOR @"878787"
#define REPAY_BORDER_COLOR @"DADADA"

@interface MSFRepaymentTableViewCell ()

/** UI **/
@property (strong, nonatomic) UILabel *contractNum;//合同编号

@property (strong, nonatomic) UILabel *contractStatus;//合同状态
@property (strong, nonatomic) UILabel *shouldAmount;//应还金额
@property (strong, nonatomic) UILabel *asOfDate;//截止日期

@property (strong, nonatomic) UILabel *contractStatusLabel;//合同状态value
@property (strong, nonatomic) UILabel *shouldAmountLabel;//应还金额value
@property (strong, nonatomic) UILabel *asOfDateLabel;//截止日期Label

//UI参数
@property (assign, nonatomic) CGFloat padding;
@property (assign, nonatomic) CGFloat topLineGuide;
@property (assign, nonatomic) CGFloat labelHeight;

@end

@implementation MSFRepaymentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		
		_padding = 8.f;
		_topLineGuide = 40.f;
		_labelHeight = 30.f;
		
		_contractNum		= [[UILabel alloc]init];
		_contractStatus = [[UILabel alloc]init];
		_shouldAmount		= [[UILabel alloc]init];
		_asOfDate				= [[UILabel alloc]init];
		_contractStatusLabel = [[UILabel alloc]init];
		_shouldAmountLabel	 = [[UILabel alloc]init];
		_asOfDateLabel			 = [[UILabel alloc]init];
		
		[_contractNum setTextColor:[MSFCommandView getColorWithString:REPAY_DARK_COLOR]];
		_contractNum.font = [UIFont systemFontOfSize:17];
		
		[_contractStatus setText:@"合同状态"];
		[_contractStatus setTextColor:[MSFCommandView getColorWithString:REPAY_LIGHT_COLOR]];
		_contractStatus.font = [UIFont systemFontOfSize:15];
		
		[_shouldAmount setText:@"应还金额"];
		[_shouldAmount setTextColor:[MSFCommandView getColorWithString:REPAY_LIGHT_COLOR]];
		_shouldAmount.font = [UIFont systemFontOfSize:15];
		
		[_asOfDate setText:@"截止日期"];
		[_asOfDate setTextColor:[MSFCommandView getColorWithString:REPAY_LIGHT_COLOR]];
		_asOfDate.font = [UIFont systemFontOfSize:15];
		
		[_contractStatusLabel setTextColor:[MSFCommandView getColorWithString:REPAY_DARK_COLOR]];
		_contractStatusLabel.font = [UIFont systemFontOfSize:15];
		[_shouldAmountLabel setTextColor:[MSFCommandView getColorWithString:REPAY_DARK_COLOR]];
		_shouldAmountLabel.font = [UIFont systemFontOfSize:15];
		[_asOfDateLabel setTextColor:[MSFCommandView getColorWithString:REPAY_DARK_COLOR]];
		_asOfDateLabel.font = [UIFont systemFontOfSize:15];
		
		[self addSubview:_contractNum];
		[self addSubview:_contractStatus];
		[self addSubview:_shouldAmount];
		[self addSubview:_asOfDate];
		[self addSubview:_contractStatusLabel];
		[self addSubview:_shouldAmountLabel];
		[self addSubview:_asOfDateLabel];
		
		@weakify(self)
		[_contractNum mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.left.equalTo(self).offset(self.padding);
			make.right.equalTo(self).offset(-self.padding);
			make.top.equalTo(self).offset(self.padding);
		}];
		[_contractStatus mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self).offset(self.topLineGuide);
			make.left.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
		}];
		[_shouldAmount mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self).offset(self.topLineGuide);
			make.left.equalTo(self.contractStatus.mas_right);
			make.height.equalTo(@(self.labelHeight));
			make.width.equalTo(self.contractStatus);
		}];
		[_asOfDate mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self).offset(self.topLineGuide);
			make.left.equalTo(self.asOfDate.mas_right);
			make.right.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
			make.width.equalTo(self.asOfDate);
		}];
		[_contractStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self.contractStatus.mas_bottom);
			make.left.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
		}];
		[_shouldAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self.shouldAmountLabel.mas_bottom);
			make.left.equalTo(self.contractStatusLabel.mas_right);
			make.height.equalTo(@(self.labelHeight));
			make.width.equalTo(self.contractStatusLabel);
		}];
		[_asOfDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self.asOfDate.mas_bottom);
			make.left.equalTo(self.shouldAmountLabel.mas_right);
			make.right.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
			make.width.equalTo(self.shouldAmountLabel);
		}];
	}
	
	return self;
}

- (void)bindViewModel:(MSFRepaymentSchedulesViewModel *)viewModel {
	_contractNum.text = [NSString stringWithFormat:@"账户编号    %@", viewModel.repaymentNumber];
	_contractStatusLabel.text = viewModel.status;
	_shouldAmountLabel.text = [NSString stringWithFormat:@"%.2f", viewModel.amount];
	_asOfDateLabel.text = viewModel.date;
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[[MSFCommandView getColorWithString:REPAY_BORDER_COLOR] setStroke];
	CGContextSetLineWidth(context, 0.5);
	
	CGContextMoveToPoint(context, 0, 0);
	CGContextAddLineToPoint(context, rect.size.width, 0);
	
	CGContextMoveToPoint(context, 0, rect.size.height);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
	
	CGContextMoveToPoint(context, rect.size.width / 3, self.topLineGuide);
	CGContextAddLineToPoint(context, rect.size.width / 3, rect.size.height - self.padding);
	
	CGContextMoveToPoint(context, rect.size.width * 2 / 3, self.topLineGuide);
	CGContextAddLineToPoint(context, rect.size.width * 2 / 3, rect.size.height - self.padding);
	
	CGContextStrokePath(context);
}

@end