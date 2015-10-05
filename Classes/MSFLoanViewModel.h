//
// MSFLoanViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@interface MSFLoanViewModel : RVMViewModel

@property (nonatomic, assign, readonly) BOOL isApply;//表明是申请还是偿还
@property (nonatomic, strong, readonly) NSString *title;// 标题
@property (nonatomic, strong, readonly) NSString *status;//状态：申请中，还款中，已逾期

/*** 申请状态 ***/
@property (nonatomic, strong, readonly) NSString *applyTime;// 申请时间 `2015-07-14`
@property (nonatomic, strong, readonly) NSString *applyLmt;// 申请金额
@property (nonatomic, strong, readonly) NSString *loanTerm;// 期数
@property (nonatomic, strong, readonly) NSString *applyNo;// 申请单号

/*** 还款状态 ***/
@property (nonatomic, strong, readonly) NSString *type;//合同/申请单
//申请单：申请金额。合同还款中为：每月应还款额；逾期状态：所有未还金额
@property (nonatomic, strong, readonly) NSString *money;
@property (nonatomic, strong, readonly) NSString *applyDate;//申请日期
@property (nonatomic, strong, readonly) NSString *period;//申请期数
@property (nonatomic, strong, readonly) NSString *currentPeriodDate;//当前期截止日期
@property (nonatomic, strong, readonly) NSString *produceType;//产品类型   循环贷/马上贷

- (instancetype)initWithModel:(id)model services:(id<MSFViewModelServices>)services;

- (void)pushDetailViewController;

@end
