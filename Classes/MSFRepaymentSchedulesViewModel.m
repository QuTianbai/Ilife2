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

@property (nonatomic, weak) id <MSFViewModelServices> services;

@end

@implementation MSFRepaymentSchedulesViewModel

- (instancetype)initWithModel:(id)model {
  self = [super init];
  if (!self) {
    return nil;
  }
	_model = model;
	RAC(self, repaymentNumber) = RACObserve(self, model.contractNum);
	RAC(self, status) = RACObserve(self, model.contractStatus);
	RAC(self, amount) = RACObserve(self, model.repaymentTotalAmount);
	RAC(self, date) = [RACObserve(self, model.repaymentTime) map:^id(id value) {
		NSDate *time = [NSDateFormatter msf_dateFromString:value];
		NSDateFormatter *df = [[NSDateFormatter alloc]init];
		df.dateFormat = @"yyyy-MM-dd";
		return [df stringFromDate:time];
	}];
	
  return self;
}

- (instancetype)initWithModel:(id)model services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_model = model;
	_services = services;
	RAC(self, repaymentNumber) = RACObserve(self, model.contractNum);
	RAC(self, status) = RACObserve(self, model.contractStatus);
	RAC(self, amount) = RACObserve(self, model.repaymentTotalAmount);
	RAC(self, date) = [[RACObserve(self, model.repaymentTime) ignore:nil] map:^id(id value) {
		NSDate *time = [NSDateFormatter msf_dateFromString:value];
		NSDateFormatter *df = [[NSDateFormatter alloc]init];
		df.dateFormat = @"yyyy-MM-dd";
		return [df stringFromDate:time];
	}];
	
  return self;
}

- (RACSignal *)fetchPlanPerodicTablesSignal {
	return [self.services.httpClient fetchPlanPerodicTables:self.model];
}

@end
