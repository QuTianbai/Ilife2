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

@implementation MSFMyRepayViewModel

- (instancetype)initWithModel:(id)model services:(id <MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_model = model;
	_services = services;
	RAC(self, loanCurrTerm) = RACObserve(self, model.loanCurrTerm);
	RAC(self, loanTerm) = RACObserve(self, model.loanTerm);
	
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		//[self fetchMyRepayListSignal].collect;
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
