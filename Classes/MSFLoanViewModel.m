//
// MSFLoanViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoanViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "MSFApplyCashInfo.h"
#import "MSFCirculateCashModel.h"

@interface MSFLoanViewModel ()

@property (nonatomic, weak) id<MSFViewModelServices>services;
@property (nonatomic, strong) id model;

@end

@implementation MSFLoanViewModel

#pragma mark - Lifecycle

- (instancetype)initWithModel:(id)model services:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_model = model;
	
	if ([model isKindOfClass:MSFApplyCashInfo.class]) {
		_title = @"贷款申请状态";
		_isApply = YES;
		MSFApplyCashInfo *tempModel = model;
		RAC(self, status) = [RACObserve(tempModel, status) map:^id(NSString *status) {
			NSDictionary *statusValues = @{@"V" : @"申请中",
																		 @"R" : @"还款中",
																		 @"O" : @"已逾期"};
			return statusValues[status];
		}];
		RAC(self, applyTime) = RACObserve(tempModel, applyTime);
		RAC(self, applyLmt) = RACObserve(tempModel, appLmt);
		RAC(self, loanTerm) = RACObserve(tempModel, loanTerm);
		RAC(self, applyNo) = RACObserve(tempModel, appNo);
	} else if ([model isKindOfClass:MSFCirculateCashModel.class]) {
		_title = @"合同还款状态";
		_isApply = NO;
		MSFCirculateCashModel *tempModel = model;
		RAC(self, status) = [RACObserve(tempModel, status) map:^id(NSString *status) {
			NSDictionary *statusValues = @{@"V" : @"申请中",
																		 @"R" : @"还款中",
																		 @"O" : @"已逾期"};
			return statusValues[status];
		}];
		RAC(self, type) = RACObserve(tempModel, type);
		RAC(self, money) = RACObserve(tempModel, money);
		RAC(self, applyDate) = RACObserve(tempModel, applyDate);
		RAC(self, period) = RACObserve(tempModel, period);
		RAC(self, currentPeriodDate) = RACObserve(tempModel, currentPeriodDate);
		RAC(self, produceType) = RACObserve(tempModel, produceType);
	}
	return self;
}

- (void)pushDetailViewController {
	[self.services pushViewModel:self.model];
}

@end
