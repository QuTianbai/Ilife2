//
//  MSFCreditViewModel.h
//  Finance
//
//  Created by Wyc on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"
#import "MSFApplication.h"

@class RACCommand ;
@class MSFApplyCashViewModel;

@interface MSFCreditViewModel : RVMViewModel

// 申请过程中的状态变化
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *subtitle;

// 申请单号
@property (nonatomic, strong, readonly) NSString *applyNumber;

// 申请金额
@property (nonatomic, strong, readonly) NSString *applyAmouts;

// 申请期数
@property (nonatomic, strong, readonly) NSString *applyTerms;

// 申请银行卡信息
@property (nonatomic, strong, readonly) NSString *applyCard;

// 申请目的
@property (nonatomic, strong, readonly) NSString *applyReason;

// 每月还款额
@property (nonatomic, strong, readonly) NSString *monthRepayAmounts;

// 申请总期数
@property (nonatomic, strong, readonly) NSString *loanMonthes __deprecated;

@property (nonatomic, strong, readonly) NSArray *photos;
@property (nonatomic, strong, readonly) NSString *groundTitle __deprecated;
@property (nonatomic, strong, readonly) NSString *groundContent __deprecated;

// 申请状态
@property (nonatomic, assign, readonly) MSFApplicationStatus status;

//申请视图中的按钮
@property (nonatomic, strong, readonly) NSString  *action;
@property (nonatomic, strong, readonly) RACCommand *excuteActionCommand;
@property (nonatomic, strong, readonly) RACCommand *excuteDrawCommand;
@property (nonatomic, strong, readonly) RACCommand *executeRepayCommand;
@property (nonatomic, strong, readonly) RACCommand *executeBillCommand;
@property (nonatomic, weak, readonly) id <MSFViewModelServices>services;

@property (nonatomic, strong, readonly) MSFApplyCashViewModel *viewModel;

- (instancetype)initWithServices:(id<MSFViewModelServices>)services;

@end
