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

- (instancetype)initWithservices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	RAC(self, loanCurrTerm) = RACObserve(self, model.loanCurrTerm);
	RAC(self, loanTerm) = RACObserve(self, model.loanTerm);
	
	_executeFetchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal return:nil];
	}];
	
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		[[[self fetchMyRepayListSignal].collect replayLazily]
		subscribeNext:^(id x) {
			
		}];
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
