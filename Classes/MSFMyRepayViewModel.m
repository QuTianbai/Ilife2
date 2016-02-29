//
//  MSFMyRepayViewModel.m
//  Finance
//
//  Created by xbm on 16/2/27.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyRepayViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFRepaymentSchedules.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "msfclient+PlanPerodicTables.h"
#import "NSDictionary+MSFKeyValue.h"

@interface MSFMyRepayViewModel ()

@property (nonatomic, strong) MSFRepaymentSchedules *model;
@property (nonatomic, readwrite) NSMutableAttributedString *repayMoney;

@end

@implementation MSFMyRepayViewModel

- (instancetype)initWithModel:(id)model {
	self = [super init];
	if (!self) {
		return nil;
	}
	_model = model;
	_contractTitle = @"";
	_repayMoney = [[NSMutableAttributedString alloc] initWithString:@""];
	_repayTime = @"";
	_applyType = @"";
	_status = @"";
	
	RAC(self, contractTitle) = [[RACObserve(self, model) ignore:nil] map:^id(MSFRepaymentSchedules *value) {
		return [NSString stringWithFormat:@"[ %@/%@ ] %@ ¥%@", value.loanCurrTerm, value.loanTerm, [NSDictionary typeStringForKey:value.contractType], value.appLmt?:@""];
	}];
	RAC(self, repayTime) = [RACObserve(self, model.repaymentTime) ignore:nil];
	RAC(self, applyType) = [RACObserve(self, model.contractType) ignore:nil];
	RAC(self, status) = [RACObserve(self, model.contractStatus) ignore:nil];
	[RACObserve(self, model)
	 subscribeNext:^(MSFRepaymentSchedules *model) {
		 NSString *str = [NSString stringWithFormat:@"本期应还：¥%@", model.repaymentTotalAmount];
		 NSMutableAttributedString *bankCardShowInfoAttributeStr = [[NSMutableAttributedString alloc] initWithString:str];
		 NSRange redRange = [str rangeOfString:[NSString stringWithFormat:@"¥%@", model.repaymentTotalAmount]];
		 
		 if ([model.contractStatus isEqualToString:@"已还款"]) {
			 [bankCardShowInfoAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, 6 + model.repaymentTotalAmount.length)];
		 } else {
			 [bankCardShowInfoAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:redRange];
		 }
		 self.repayMoney = bankCardShowInfoAttributeStr;
	 }];
	
	return self;
}

- (RACSignal *)fetchMyRepayListSignal {
	return nil;
}

- (RACSignal *)fetchPlanPerodicTablesSignal {
	return [self.services.httpClient fetchPlanPerodicTables:self.model];
}

@end
