//
// MSFLoanViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFLoanViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFApplyList.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

@interface MSFLoanViewModel ()

@property (nonatomic, strong) MSFApplyList *loan;
@property (nonatomic, weak) id<MSFViewModelServices>services;

@end

@implementation MSFLoanViewModel

#pragma mark - Lifecycle

- (instancetype)initWithModel:(MSFApplyList *)model services:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	
	RAC(self, status) = [RACObserve(model, status) map:^id(id status) {
		NSDictionary *statusValues = @{
			@(MSFLoanStatusNone): @"无效",
			@(MSFLoanStatusAppling): @"审核中",
			@(MSFLoanStatusSuccess): @"审核通过",
			@(MSFLoanStatusFailed): @"审核未通过",
			@(MSFLoanStatusRepayment): @"还款中",
			@(MSFLoanStatusCancel): @"已取消",
			@(MSFLoanStatusFinished): @"已完结",
			@(MSFLoanStatusExpired): @"已逾期",
			@(MSFLoanStatusExpectedSuccess): @"预审核通过",
			@(MSFLoanStatusLoan): @"待放款",
		};
		
		return statusValues[@([status integerValue])];
	}];
	
	RAC(self, applyDate) = [RACObserve(model, apply_time) map:^id(id date){
		return [NSDateFormatter msf_Chinese_stringFromDate:date];
	}];
	RAC(self, title) = [RACObserve(model, status) map:^id(id value) {
		NSInteger intStatus = [value integerValue];
		if (intStatus < 4 || intStatus == 8) {
			return @"贷款申请状态";
		} else {
			return @"贷款处理状态";
		}
	}];
	RAC(self, repaidAmount) = [RACObserve(model, payed_amount) map:^id(id value) {
		return [NSString stringWithFormat:@"%@", value];
	}];
	RAC(self, totalAmount) = [RACObserve(model, total_amount) map:^id(id value) {
		return [NSString stringWithFormat:@"%@", value];
	}];
	RAC(self, mothlyRepaymentAmount) = [RACObserve(model, monthly_repayment_amount) map:^id(id value) {
		return [NSString stringWithFormat:@"%@", value];
	}];
	
	_totalInstallments = model.total_installments;
	_currentInstallment = model.current_installment;
	
	return self;
}

- (void)pushHistoryDetails {
	[self.services pushViewModel:self];
}

@end
