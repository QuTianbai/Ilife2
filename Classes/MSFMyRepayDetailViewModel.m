//
//  MSFMyRepayDetailViewModel.m
//  Finance
//
//  Created by xbm on 16/3/1.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyRepayDetailViewModel.h"
#import "MSFMyRepayDetailModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+RepaymentSchedules.h"
#import "MSFCmdtyModel.h"
#import "MSFDrawModel.h"
#import "MSFCmdDetailViewModel.h"
#import "MSFWithDrawViewModel.h"

@interface MSFMyRepayDetailViewModel ()

@property (nonatomic, assign) id<MSFViewModelServices> services;
@property (nonatomic, strong) MSFMyRepayDetailModel *model;

@end

@implementation MSFMyRepayDetailViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_contractNo = @"";
	_latestDueMoney = @"";
	_latestDueDate = @"";
	_type = @"";
	_appLmt = @"";
	_loanTerm = @"";
	_loanCurrTerm = @"";
	_loanExpireDate = @"";
	_totalOverdueMoney = @"";
	_interest = @"";
	_applyDate = @"";
//	_cmdtyList = @[];
//	_withdrawList = @[];
	
	RAC(self, contractNo) = [RACObserve(self, model.contractNo) ignore:nil];
	RAC(self, latestDueMoney) = [RACObserve(self, model.latestDueMoney) ignore:nil];
	RAC(self, latestDueDate) = [[RACObserve(self, model.latestDueDate) ignore:nil] map:^id(NSString *value) {
		return [NSString stringWithFormat:@"账单日：每月%@日", value];
	}];
	RAC(self, type) = [RACObserve(self, model.type) ignore:nil];
	RAC(self, appLmt) = [RACObserve(self, model.appLmt) ignore:nil];
	RAC(self, loanCurrTerm) = [RACObserve(self, model.loanCurrTerm) ignore:nil];
	RAC(self, loanTerm) = [RACObserve(self, model.loanTerm) ignore:nil];
	RAC(self, loanExpireDate) = [RACObserve(self, model.loanExpireDate) ignore:nil];
	RAC(self, totalOverdueMoney) = [RACObserve(self, model.totalOverdueMoney) ignore:nil];
	RAC(self, interest) = [RACObserve(self, model.interest) ignore:nil];
	RAC(self, applyDate) = [RACObserve(self, model.applyDate) ignore:nil];
	RAC(self, cmdtyList) = [[RACObserve(self, model.cmdtyList) ignore:nil] map:^id(NSArray *values) {
		NSMutableArray *valueArray = [[NSMutableArray alloc] init];
		for (MSFCmdtyModel *model in values) {
			[valueArray addObject:[[MSFCmdDetailViewModel alloc] initWithModel:model]];
		}
		
		return [NSArray arrayWithArray:valueArray];
	}];
	RAC(self, withdrawList) = [[RACObserve(self, model.withdrawList) ignore:nil] map:^id(NSArray *values) {
		NSMutableArray *valueArray = [[NSMutableArray alloc] init];
		for (MSFDrawModel *model in values) {
			[valueArray addObject:[[MSFWithDrawViewModel alloc] initWithModel:model]];
		}
		
		return [NSArray arrayWithArray:valueArray];
	}];
	RAC(self, contractTitle) = [[RACObserve(self, model) ignore:nil] map:^id(MSFMyRepayDetailModel *value) {
		return [NSString stringWithFormat:@"[%@] %@/%@期账单", value.type, value.loanCurrTerm, value.loanTerm];
	}];
	
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		[[self.services.httpClient fetchMyDetailWithContractNo:self.contractNo type:self.type]
		 subscribeNext:^(MSFMyRepayDetailModel *x) {
			 self.model = x;
		 } error:^(NSError *error) {
			 NSLog(@"error:%@", error);
		 }];
	}];
	@weakify(self)
	[RACObserve(self, cmdtyList) subscribeNext:^(id x) {
		[_executeFetchCommand execute:@"1"];
	}];
	_executeFetchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSString *input) {
		@strongify(self)
		if ([input isEqualToString:@"1"] || [input isEqualToString:@"3"]) {
			return [RACSignal return:[self.cmdtyList.rac_sequence filter:^BOOL(MSFCmdDetailViewModel *viewModel) {
				return YES;
			}].array];
		}
		return [RACSignal return:[self.cmdtyList.rac_sequence filter:^BOOL(MSFCmdDetailViewModel *viewModel) {
			return YES;
		}].array];
		
	}];
	
	return self;
}

@end
