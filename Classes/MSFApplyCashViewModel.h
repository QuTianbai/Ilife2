//
//  MSFApplyCashVIewModel.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"
#import "MSFSelectKeyValues.h"
#import "MSFApplicationViewModel.h"

@class MSFFormsViewModel;
@class RACCommand;
@class MSFApplyCashModel;
@class MSFAmortize;
@class MSFPlan;
@class MSFLoanType;

@interface MSFApplyCashViewModel : RVMViewModel <MSFApplicationViewModel>

@property (nonatomic, copy) NSString *appNO;
@property (nonatomic, copy) NSString *appLmt; // 贷款金额
@property (nonatomic, copy) NSString *applyStatus;
@property (nonatomic, strong, readwrite) NSString *loanTerm; // 贷款期数
@property (nonatomic, copy) NSString *loanPurpose;
@property (nonatomic, copy) NSString *jionLifeInsurance;
@property (nonatomic, copy) NSString *lifeInsuranceAmt;
@property (nonatomic, copy) NSString *loanFixedAmt;
@property (nonatomic, copy) NSString *productCd;
@property (nonatomic, strong) NSArray *array;

// 贷款目的
@property (nonatomic, strong) MSFSelectKeyValues *purpose;
@property (nonatomic, strong, readonly) NSString *purposeText;

// 金额
@property (nonatomic, copy) NSString *minMoney;
@property (nonatomic, copy) NSString *maxMoney;

// 贷款期数对应的产品
@property (nonatomic, strong) MSFPlan *product;

@property (nonatomic, strong) MSFApplyCashModel *model;
@property (nonatomic, strong) MSFAmortize *markets;

@property (nonatomic, strong, readonly) RACCommand *executeLifeInsuranceCommand;
@property (nonatomic, strong, readonly) RACCommand *executePurposeCommand;
@property (nonatomic, strong, readonly) RACCommand *executeTermCommand;
@property (nonatomic, strong, readonly) RACCommand *executeNextCommand;

@property (nonatomic, copy) NSString *masterBankCardNameAndNO;

// 提交贷款申请信息
//
// status -  状态 0: 保存贷款信息 1: 提交信息到服务器审核
//
// Returns a signal will send instance of `MSFSubmitApplyModel`
- (RACSignal *)submitSignalWithStatus:(NSString *)status;


// 创建ViewModel instance
//
// viewModel - 用户信息: 基本信息/职业信息/联系人信息
// loanType  - 贷款产品群  社保贷/马上贷 etc.
//
// Returns a instance of `MSFApplyCashModel`
- (instancetype)initWithViewModel:(id)viewModel loanType:(MSFLoanType *)loanType __deprecated_msg("Use initWithLoanType: services: intead");
- (instancetype)initWithLoanType:(MSFLoanType *)loanType services:(id <MSFViewModelServices>)services;


// <MSFApplicationViewModel>
@property (nonatomic, strong) NSArray *accessories;
@property (nonatomic, strong) MSFLoanType *loanType;
@property (nonatomic, strong, readwrite) NSString *applicationNo;
@property (nonatomic, strong, readwrite) NSString *amount;
@property (nonatomic, strong) id formViewModel __deprecated_msg("Use MSFUser intead");
@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

//TODO: 完成马上贷数据提交
@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;

@end

