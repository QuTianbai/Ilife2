//
// MSFRepaymentSchedulesViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class MSFRepaymentSchedules;

@interface MSFRepaymentSchedulesViewModel : RVMViewModel

@property (nonatomic, readonly) MSFRepaymentSchedules *model;

// 合同编号
@property (nonatomic, readonly) NSString *repaymentNumber;

// 还款状态 eg. `逾期`
@property (nonatomic, readonly) NSString *status;

// 还款金额
@property (nonatomic, readonly) double amount;

// 应还款日期
@property (nonatomic, readonly) NSString *date;

- (instancetype)initWithModel:(id)model __deprecated_msg("Use initWithModel:services:");
- (instancetype)initWithModel:(id)model services:(id <MSFViewModelServices>)services;;

- (RACSignal *)fetchPlanPerodicTablesSignal;

@end
