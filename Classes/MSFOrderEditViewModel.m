//
//  MSFOrderEditViewModel.m
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFOrderEditViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFOrderEditViewModel ()

@property (nonatomic, assign) double totalAmt;

@end

@implementation MSFOrderEditViewModel

- (instancetype)initWithOrderId:(NSString *)orderId
											 services:(id<MSFViewModelServices>)services {
	self = [super init];
	if (self) {
		_services = services;
		
		_downPmtPct = @"0.25";
		_downPmtAmt = @"1000"; // 首付金额
		_loanAmt = @"3000"; // 分期总金额
		_loanTerms = @[@{@"price" : @"446",
										 @"term" : @"3"},
									 @{@"price" : @"232",
										 @"term" : @"6"}];
		_joinInsurance = NO; // 是否加入寿险计划
		_insurance = @"10.00";
		_trialAmt = @"1312.32";
		_commodities = @[@{@"cate1" : @"电器",
											 @"cate2" : @"电视",
											 @"shop" : @"加上家",
											 @"name" : @"海尔",
											 @"price" : @"2000",
											 @"num" : @"1"},
										 @{@"cate1" : @"电器",
											 @"cate2" : @"空调",
											 @"shop" : @"加上家",
											 @"name" : @"格力",
											 @"price" : @"2000",
											 @"num" : @"1"}];
		
		_totalAmt = _downPmtAmt.doubleValue + _loanAmt.doubleValue;
		
		RACChannelTerminal *percent = RACChannelTo(self, downPmtPct);
		RACChannelTerminal *downPmt = RACChannelTo(self, downPmtAmt);
		RACChannelTerminal *loanAmt = RACChannelTo(self, loanAmt);
		
		[[percent map:^id(NSString *value) {
			double down = self.totalAmt * value.doubleValue;
			return [NSString stringWithFormat:@"%.2f", down];
		}] subscribe:downPmt];
		[[percent map:^id(NSString *value) {
			double loan = self.totalAmt * (1 - value.doubleValue);
			return [NSString stringWithFormat:@"%.2f", loan];
		}] subscribe:loanAmt];
		[[downPmt map:^id(NSString *value) {
			double per = value.doubleValue / self.totalAmt;
			return [NSString stringWithFormat:@"%.3f", per];
		}] subscribe:percent];
		[[downPmt map:^id(NSString *value) {
			double loan = self.totalAmt - value.doubleValue;
			return [NSString stringWithFormat:@"%.2f", loan];
		}] subscribe:loanAmt];
	}
	return self;
}

- (NSString *)reuseIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == self.commodities.count) {
		switch (indexPath.row) {
			case 0: return @"MSFOrderEditInputCell";
			case 1: return @"MSFOrderEditContentCell";
			case 2: return @"MSFOrderEditLoanTermCell";
			case 3: return @"MSFOrderEditSwitchCell";
			case 4: return @"MSFOrderEditTrialCell";
		}
	} else {
		if (indexPath.row == 0) {
			return @"MSFOrderEditCategoryCell";
		}
		return @"MSFOrderEditContentCell";
	}
	return nil;
}

@end
