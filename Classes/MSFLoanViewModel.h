//
// MSFLoanViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@interface MSFLoanViewModel : RVMViewModel

@property (nonatomic, strong, readonly) NSString *type;//合同/申请单
@property (nonatomic, strong, readonly) NSString *title;// 标题
@property (nonatomic, strong, readonly) NSString *money;//申请单：申请金额。合同还款中为：每月应还款额；逾期状态：所有未还金额
@property (nonatomic, strong, readonly) NSString *loanTerm;	// 期数

/*** 申请状态 ***/
@property (nonatomic, strong, readonly) NSString *applyStatus;//状态：申请中，还款中，已逾期
@property (nonatomic, strong, readonly) NSString *applyTime;// 申请时间 `2015-07-14`
//@property (nonatomic, strong, readonly) NSString *applyNo;	// 申请单号

/*** 还款状态 ***/
@property (nonatomic, strong, readonly) NSString *contractStatus; //合同状态
@property (nonatomic, strong, readonly) NSString *applyDate;//申请日期
@property (nonatomic, strong, readonly) NSString *currentPeriodDate;//当前期截止日期

@property (nonatomic, weak, readonly) id<MSFViewModelServices>services;

- (instancetype)initWithModel:(id)model services:(id<MSFViewModelServices>)services;
- (void)pushDetailViewController;

- (RACSignal *)fetchApplyListSignal;
- (RACSignal *)fetchRepaymentSchedulesSignal;

@end
