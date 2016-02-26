//
// MSFRepaymentSchedulesViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFRepaymentSchedulesViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFRepaymentSchedules.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "msfclient+PlanPerodicTables.h"

@interface MSFRepaymentSchedulesViewModel ()

@property (nonatomic, readwrite) NSString *date;

@end

@implementation MSFRepaymentSchedulesViewModel

- (instancetype)initWithModel:(id)model services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_smsCode = @"";
	_model = model;
	_services = services;
	RAC(self, loanCurrTerm) = RACObserve(self, model.loanCurrTerm);
	RAC(self, loanTerm) = RACObserve(self, model.loanTerm);
	RAC(self, applyType) = RAC(<#TARGET, ...#>)
//	RAC(self, status) = [RACObserve(self, model.contractStatus) ignore:nil];
//	RAC(self, amount) = [RACObserve(self, model.repaymentTotalAmount) ignore:nil];
//	RAC(self, date) = [RACObserve(self, model.repaymentTime) map:^id(NSString *value) {
//		return value.length > 0 ? value : @"当天";
//	}];
//	
//	RAC(self, ownerAllMoney) = [RACObserve(self, model.applmt) map:^id(id value) {
//		if (value == nil) {
//			return @"";
//		}
//		return value;
//	}];
//	RAC(self, contractLineDate) = [RACObserve(self, model.repaymentTime) map:^id(NSString *value) {
//		return value.length > 0 ? value : @"当天";
//	}];
	
//	RAC(self, overdueMoney) = [RACObserve(self, model.rep) map:^id(id value) {
//		if (value == nil || [value isEqualToString:@"0.00"] ||[value isEqualToString:@"0"] || [value isEqualToString:@""]) {
//			return @"";
//		}
//		return [NSString stringWithFormat:@"已逾期:￥%@", value];
//	}];
//	
//	RAC(self, cashAmount) = [RACObserve(self, model.cashDueMoney) ignore:nil];
//	RAC(self, cashDate) = [RACObserve(self, model.cashDueDate) map:^id(NSString *value) {
//		return value.length > 0 ? value : @"当天";
//	}];
	
  return self;
}

- (RACSignal *)fetchPlanPerodicTablesSignal {
	return [self.services.httpClient fetchPlanPerodicTables:self.model];
}

- (RACSignal *)repayMoneySignal {
	return nil;
}

@end
