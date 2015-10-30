//
//  MSFHomePageCellModel.h
//  Finance
//
//  Created by 赵勇 on 10/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@interface MSFHomePageCellModel : RVMViewModel

@property (nonatomic, weak) id<MSFViewModelServices>services;

/*
 *马上贷
 */

//合同/申请单(CONTRACT/APPLY)
@property (nonatomic, strong) NSString *type;

// 标题
@property (nonatomic, strong) NSString *title;

//申请：申请金额；合同：每月应还款额；逾期：所有未还金额
@property (nonatomic, strong) NSString *money;

// 期数
@property (nonatomic, strong) NSString *loanTerm;

//状态码
@property (nonatomic, strong) NSString *status;

//状态描述
@property (nonatomic, strong) NSString *statusString;

//跳转目标。1，申请列表；2，还款列表；3，合同确认
@property (nonatomic, assign) NSInteger jumpDes;

//申请时间（申请单独有）
@property (nonatomic, strong) NSString *applyTime;

//申请日期（合同独有）
@property (nonatomic, strong) NSString *applyDate;

//当前期截止日期（合同独有）
@property (nonatomic, strong) NSString *currentPeriodDate;

/*
 *随借随还
 */

//总额度
@property (nonatomic, strong) NSString *totalLimit;

//已用额度
@property (nonatomic, strong) NSString *usedLimit;

//可用额度
@property (nonatomic, strong) NSString *usableLimit;

//逾期金额
@property (nonatomic, strong) NSString *overdueMoney;

//合同到期时间
@property (nonatomic, strong) NSString *contractExpireDate;

//最近应还款金额
@property (nonatomic, strong) NSString *latestDueMoney;

//最近还款日
@property (nonatomic, strong) NSString *latestDueDate;

//总欠款额
@property (nonatomic, strong) NSString *totalOverdueMoney;

//合同号
@property (nonatomic, strong) NSString *contractNo;

//合同状态
@property (nonatomic, strong) NSString *contractStatus;

- (instancetype)initWithModel:(id)model
										 services:(id<MSFViewModelServices>)services;
- (RACSignal *)fetchApplyListSignal;
- (RACSignal *)fetchRepaymentSchedulesSignal;
- (void)pushDetailViewController;

@end
