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

@property (nonatomic, copy) NSString *smsCode;

@property (nonatomic, weak) id <MSFViewModelServices> services;

@property (nonatomic, readonly) MSFRepaymentSchedules *model;

// 合同商品title
@property (nonatomic, readonly) NSString *contractTitle;
//当前期数
@property (nonatomic, readonly) NSString *loanCurrTerm;
//贷款期数
@property (nonatomic, readonly) NSString *loanTerm;
//贷款类型
@property (nonatomic, readonly) NSString *applyType;

// 还款日
@property (nonatomic, readonly) NSString *repayTime;

// 本期应还款金额
@property (nonatomic, readonly) NSString *repayMoney;

///////////////////////////////////////////////////////////////////

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

//类型
@property (nonatomic, assign) int type;
//还款

//马上贷
@property (nonatomic, readonly) double cashAmount;

@property (nonatomic, readonly) NSString *cashDate;

- (instancetype)initWithModel:(id)model services:(id <MSFViewModelServices>)services;;

- (RACSignal *)fetchPlanPerodicTablesSignal;

@end
