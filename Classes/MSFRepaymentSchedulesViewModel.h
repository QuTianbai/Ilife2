//
// MSFRepaymentSchedulesViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class MSFRepaymentSchedules;
@class RACCommand;

@interface MSFRepaymentSchedulesViewModel : RVMViewModel

@property (nonatomic, weak) id <MSFViewModelServices> services;

@property (nonatomic, readonly) MSFRepaymentSchedules *model;

// 合同编号
@property (nonatomic, readonly) NSString *repaymentNumber;

// 还款状态 eg. `逾期`
@property (nonatomic, readonly) NSString *status;

// 还款金额
@property (nonatomic, readonly) double amount;

// 应还款日期
@property (nonatomic, readonly) NSString *date;

//欠款总额
@property (nonatomic, readonly) NSString *ownerAllMoney;

//合同截止日期
@property (nonatomic, readonly) NSString *contractLineDate;

@property (nonatomic, readonly) NSString *overdueMoney;

@property (nonatomic, strong) RACCommand *repayMoneyCommand;

//马上贷
@property (nonatomic, readonly) double cashAmount;

@property (nonatomic, readonly) NSString *cashDate;

- (instancetype)initWithModel:(id)model services:(id <MSFViewModelServices>)services;;

- (RACSignal *)fetchPlanPerodicTablesSignal;

@end
