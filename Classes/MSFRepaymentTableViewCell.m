//
//	MSFRepaymentTableViewCell.m
//	Cash
//
//	Created by xutian on 15/5/17.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFRepaymentTableViewCell.h"
#import <Mantle/EXTScope.h>
#import <Masonry/Masonry.h>
#import "MSFRepaymentSchedulesViewModel.h"
#import "MSFCommandView.h"
#import "MSFEdgeButton.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFDrawCashViewModel.h"
#import "MSFUser.h"
#import "MSFClient+Users.h"
#import "AppDelegate.h"
#import "MSFClient+BankCardList.h"
#import "MSFRepaymentViewModel.h"
#import <SVProgressHUD/SVProgressHUD.h>

#define REPAY_DARK_COLOR  @"464646"
#define REPAY_LIGHT_COLOR @"878787"
#define REPAY_BORDER_COLOR @"DADADA"

@interface MSFRepaymentTableViewCell ()

@property (nonatomic, strong) MSFRepaymentSchedulesViewModel *viewModel;

@property (nonatomic, strong) id<MSFViewModelServices> services;

/** UI **/
@property (strong, nonatomic) UILabel *contractNum;//合同编号

@property (strong, nonatomic) UILabel *contractStatus;//合同状态
@property (strong, nonatomic) UILabel *shouldAmount;//应还金额
@property (strong, nonatomic) UILabel *asOfDate;//截止日期

@property (strong, nonatomic) UILabel *contractStatusLabel;//合同状态value
@property (strong, nonatomic) UILabel *shouldAmountLabel;//应还金额value
@property (strong, nonatomic) UILabel *asOfDateLabel;//截止日期Label

//UI参数
@property (assign, nonatomic) CGFloat topMargin;
@property (assign, nonatomic) CGFloat padding;
@property (assign, nonatomic) CGFloat topHeight;
@property (assign, nonatomic) CGFloat labelHeight;
@property (assign, nonatomic) CGFloat topLineGuide;

@end

@implementation MSFRepaymentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		_topMargin = 13.f;
		_padding = 8.f;
		_topHeight = 40.f;
		_labelHeight = 30.f;
		_topLineGuide = _topHeight + _topMargin;
		
		_contractNum				 = [[UILabel alloc]init];
		_contractStatus			 = [[UILabel alloc]init];
		_shouldAmount				 = [[UILabel alloc]init];
		_asOfDate						 = [[UILabel alloc]init];
		_contractStatusLabel = [[UILabel alloc]init];
		_shouldAmountLabel	 = [[UILabel alloc]init];
		_asOfDateLabel			 = [[UILabel alloc]init];
		_repayButton				 = [[MSFEdgeButton alloc] init];
		
		[_contractNum setTextColor:[MSFCommandView getColorWithString:REPAY_DARK_COLOR]];
		_contractNum.font = [UIFont systemFontOfSize:15];
		
		[_contractStatus setText:@"合同状态"];
		[_contractStatus setTextColor:[MSFCommandView getColorWithString:REPAY_LIGHT_COLOR]];
		_contractStatus.font = [UIFont systemFontOfSize:13];
		_contractStatus.textAlignment = NSTextAlignmentCenter;
		
		[_shouldAmount setText:@"应还金额"];
		[_shouldAmount setTextColor:[MSFCommandView getColorWithString:REPAY_LIGHT_COLOR]];
		_shouldAmount.font = [UIFont systemFontOfSize:13];
		_shouldAmount.textAlignment = NSTextAlignmentCenter;
		
		[_asOfDate setText:@"截止日期"];
		[_asOfDate setTextColor:[MSFCommandView getColorWithString:REPAY_LIGHT_COLOR]];
		_asOfDate.font = [UIFont systemFontOfSize:13];
		_asOfDate.textAlignment = NSTextAlignmentCenter;
		
		[_contractStatusLabel setTextColor:[MSFCommandView getColorWithString:REPAY_DARK_COLOR]];
		_contractStatusLabel.font = [UIFont systemFontOfSize:13];
		_contractStatusLabel.textAlignment = NSTextAlignmentCenter;
		[_shouldAmountLabel setTextColor:[MSFCommandView getColorWithString:REPAY_DARK_COLOR]];
		_shouldAmountLabel.font = [UIFont systemFontOfSize:13];
		_shouldAmountLabel.textAlignment = NSTextAlignmentCenter;
		[_asOfDateLabel setTextColor:[MSFCommandView getColorWithString:REPAY_DARK_COLOR]];
		_asOfDateLabel.font = [UIFont systemFontOfSize:13];
		_asOfDateLabel.textAlignment = NSTextAlignmentCenter;
		
		[_repayButton setTitle:@"还款" forState:UIControlStateNormal];
		
		[self addSubview:_repayButton];
		
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
			make.top.equalTo(self).offset(self.topMargin);
			make.height.equalTo(@(self.topHeight));
		}];
		[_contractStatus mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self).offset(_topLineGuide);
			make.left.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
		}];
		[_shouldAmount mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self).offset(_topLineGuide);
			make.left.equalTo(self.contractStatus.mas_right);
			make.height.equalTo(@(self.labelHeight));
		}];
		[_asOfDate mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self).offset(_topLineGuide);
			make.left.equalTo(self.shouldAmount.mas_right);
			make.right.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
			make.width.equalTo(@[_contractStatus, _shouldAmount]);
		}];
		[_contractStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self.contractStatus.mas_bottom);
			make.left.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
		}];
		[_shouldAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self.shouldAmount.mas_bottom);
			make.left.equalTo(self.contractStatusLabel.mas_right);
			make.height.equalTo(@(self.labelHeight));
		}];
		[_asOfDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self.asOfDate.mas_bottom);
			make.left.equalTo(self.shouldAmountLabel.mas_right);
			make.right.equalTo(self);
			make.height.equalTo(@(self.labelHeight));
			make.width.equalTo(@[_contractStatusLabel, _shouldAmountLabel]);
		}];
		
		[_repayButton mas_makeConstraints:^(MASConstraintMaker *make) {
			@strongify(self)
			make.top.equalTo(self.asOfDateLabel.mas_bottom).offset(30);
			make.left.equalTo(self).offset(15);
			make.right.equalTo(self).offset(-15);
			make.height.equalTo(@(40));
		}];
	}
	
	return self;
}

- (void)bindViewModel:(MSFRepaymentSchedulesViewModel *)viewModel {
	self.viewModel = viewModel;
	_contractNum.text = [NSString stringWithFormat:@"合同编号    %@", viewModel.repaymentNumber];
	_contractStatusLabel.text = viewModel.status;
	_shouldAmountLabel.text = [NSString stringWithFormat:@"%.2f", viewModel.cashAmount];
	_asOfDateLabel.text = viewModel.cashDate;
	if ([viewModel.status isEqualToString:@"已逾期"]) {
		_repayButton.hidden = NO;
		[[_repayButton rac_signalForControlEvents:UIControlEventTouchUpInside]
		subscribeNext:^(id x) {
			self.services = viewModel.services;
			
			if ([self hasTransactionalCode]) {
				[[[self.services.httpClient fetchBankCardList].collect replayLazily] subscribeNext:^(id x) {
					[SVProgressHUD dismiss];
					NSArray *dataArray = x;
					if (dataArray.count == 0) {
						[[[UIAlertView alloc] initWithTitle:@"提示" message:@"请先添加银行卡" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
					} else {
						[dataArray enumerateObjectsUsingBlock:^(MSFBankCardListModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
							if (obj.master) {
								MSFRepaymentViewModel *repaypmentviewModel = [[MSFRepaymentViewModel alloc] initWithViewModel:viewModel services:self.services];
								[viewModel.services pushViewModel:repaypmentviewModel];
								*stop = YES;
							}
						}];
					}
				}];
			}
		}];
	} else {
		_repayButton.hidden = YES;
	}
}

- (void)drawRect:(CGRect)rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	[[MSFCommandView getColorWithString:REPAY_BORDER_COLOR] setStroke];
	CGContextSetLineWidth(context, 0.5);
	
	CGContextMoveToPoint(context, 0, _topMargin + 0.5);
	CGContextAddLineToPoint(context, rect.size.width, _topMargin + 0.5);
	
	CGContextMoveToPoint(context, 0, rect.size.height - 0.5);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height - 0.5);
	
	CGContextMoveToPoint(context, rect.size.width / 3, self.topLineGuide);
	
	if ([self.viewModel.status isEqualToString:@"已逾期"]) {
		CGContextAddLineToPoint(context, rect.size.width / 3, rect.size.height - self.padding - 70);
	} else {
		CGContextAddLineToPoint(context, rect.size.width / 3, rect.size.height - self.padding);
	}
	CGContextMoveToPoint(context, rect.size.width * 2 / 3, self.topLineGuide);
	if ([self.viewModel.status isEqualToString:@"已逾期"]) {
		CGContextAddLineToPoint(context, rect.size.width * 2 / 3, rect.size.height - self.padding - 70);
	} else {
		CGContextAddLineToPoint(context, rect.size.width * 2 / 3, rect.size.height - self.padding);
	}
	CGContextStrokePath(context);
}

- (BOOL)hasTransactionalCode {
	MSFUser *user = self.services.httpClient.user;
	if (!user.hasTransactionalCode) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请先设置交易密码" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
		[alert show];
		[alert.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
			if (index.intValue == 1) {
				AppDelegate *delegate = [UIApplication sharedApplication].delegate;
				[self.services pushViewModel:delegate.authorizeVewModel];
			}
		}];
		return NO;
	}
	return YES;
}

@end