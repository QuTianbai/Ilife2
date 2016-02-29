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

@end

@implementation MSFMyRepayViewModel

- (instancetype)initWithModel:(id)model {
	self = [super init];
	if (!self) {
		return nil;
	}
	_model = model;
	_contractTitle = @"";
	_repayMoney = @"";
	_repayTime = @"";
	_applyType = @"";
	_status = @"";
	
	RAC(self, contractTitle) = [[RACObserve(self, model) ignore:nil] map:^id(MSFRepaymentSchedules *value) {
		return [NSString stringWithFormat:@"[ %@/%@ ] %@ ¥%@", value.loanCurrTerm, value.loanTerm, [NSDictionary typeStringForKey:value.contractType], value.appLmt?:@""];
	}];
	RAC(self, repayMoney) = [[RACObserve(self, model.repaymentTotalAmount) ignore:nil] map:^id(NSString *value) {
		return [NSString stringWithFormat:@"本期应还：%@", value];
	}];
	RAC(self, repayTime) = [RACObserve(self, model.repaymentTime) ignore:nil];
	RAC(self, applyType) = [RACObserve(self, model.contractType) ignore:nil];
	RAC(self, status) = [RACObserve(self, model.contractStatus) ignore:nil];
	
	return self;
}

- (RACSignal *)fetchMyRepayListSignal {
	return nil;
}

- (RACSignal *)fetchPlanPerodicTablesSignal {
	return [self.services.httpClient fetchPlanPerodicTables:self.model];
}

@end
