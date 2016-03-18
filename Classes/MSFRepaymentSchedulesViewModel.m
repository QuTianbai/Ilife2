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
	
  return self;
}

- (RACSignal *)fetchPlanPerodicTablesSignal {
	return [self.services.httpClient fetchPlanPerodicTables:self.model];
}

- (RACSignal *)repayMoneySignal {
	return nil;
}

@end
