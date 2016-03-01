//
//  MSFMyRepayViewModel.h
//  Finance
//
//  Created by xbm on 16/2/27.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class MSFRepaymentSchedules;
@class RACCommand;

@interface MSFMyRepayViewModel : RVMViewModel

@property (nonatomic, copy) NSString *type;

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
@property (nonatomic, readonly) NSMutableAttributedString *repayMoney;
//合同状态
@property (nonatomic, readonly) NSString *status;

- (instancetype)initWithModel:(id)model;

//- (instancetype)initWithservices:(id <MSFViewModelServices>)services;;

//- (RACSignal *)fetchPlanPerodicTablesSignal;

@end
