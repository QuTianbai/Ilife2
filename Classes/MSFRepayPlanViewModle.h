//
//  MSFRepayPlayMode.h
//  Finance
//
//  Created by Wyc on 16/3/17.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"
#import "MSFViewModelServices.h"
#import <ReactiveViewModel/ReactiveViewModel.h>

@interface MSFRepayPlanViewModle : MSFObject

//合同编号
@property (nonatomic, copy, readonly) NSString *contractNum;
//还款状态
@property (nonatomic, copy, readonly) NSString *contractStatus;
//最近还款日
@property (nonatomic, copy, readonly) NSString *repaymentTime;
//应还金额
@property (nonatomic, copy, readonly) NSString *repaymentTotalAmount;
//类型
@property (nonatomic, copy, readonly) NSString *contractType;
//贷款金额
@property (nonatomic, assign, readonly) NSString *appLmt;
//贷款期数
@property (nonatomic, assign, readonly) NSString *loanTerm;
//当前期数
@property (nonatomic, copy, readonly) NSString *loanCurrTerm;
//账期
@property (nonatomic, copy, readonly) NSString *loanExpireDate;

@property (nonatomic, copy, readonly) NSString *status;


- (instancetype)initWithModel:(id)model;

@end
