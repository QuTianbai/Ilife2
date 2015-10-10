//
// MSFLoanViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoanViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCirculateCashModel.h"

@interface MSFLoanViewModel ()

@property (nonatomic, weak) id<MSFViewModelServices>services;
@property (nonatomic, strong) MSFCirculateCashModel *model;

@end

@implementation MSFLoanViewModel

#pragma mark - Lifecycle

- (instancetype)initWithModel:(MSFCirculateCashModel *)model services:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_model = model;
	
	RAC(self, type) = RACObserve(model, type);
	RAC(self, title) = [RACObserve(model, type) map:^id(NSString *type) {
		if ([type isEqualToString:@"APPLY"]) {
			return @"贷款申请状态";
		} else {
			return @"合同还款状态";
		}
	}];
	RAC(self, applyStatus) = [RACObserve(model, applyStatus) map:^id(NSString *status) {
		NSDictionary *statusValues = @{@"A" : @"",
																	 @"B" : @"审核中",
																	 @"C" : @"确认合同",
																	 @"D" : @"审核未通过",
																	 @"E" : @"待放款",
																	 @"F" : @"还款中",
																	 @"G" : @"已取消",
																	 @"H" : @"已还款",
																	 @"I" : @"已逾期",
																	 @"J" : @"已到期"};
		return statusValues[status];
	}];
	RAC(self, contractStatus) = [RACObserve(model, contractStatus) map:^id(NSString *contractStatus) {
		NSDictionary *statusValues = @{@"A" : @"",
																	 @"B" : @"审核中",
																	 @"C" : @"确认合同",
																	 @"D" : @"审核未通过",
																	 @"E" : @"待放款",
																	 @"F" : @"还款中",
																	 @"G" : @"已取消",
																	 @"H" : @"已还款",
																	 @"I" : @"已逾期",
																	 @"J" : @"已到期"};
		return statusValues[contractStatus];
	}];
	RAC(self, money) = RACObserve(model, money);
	RAC(self, loanTerm) = RACObserve(model, period);
	
	/*** 申请状态 ***/
	RAC(self, applyTime) = RACObserve(model, applyDate);
	//RAC(self, applyNo) = RACObserve(model, contractNo);
	
	/*** 还款状态 ***/
	RAC(self, applyDate) = RACObserve(model, applyDate);
	RAC(self, currentPeriodDate) = RACObserve(model, currentPeriodDate);

	return self;
}

- (void)pushDetailViewController {
	[self.services pushViewModel:self];
}

@end
