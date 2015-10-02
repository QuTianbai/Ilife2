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

@class MSFFormsViewModel;
@class RACCommand;
@class MSFApplyCashModel;
@interface MSFApplyCashVIewModel : RVMViewModel

@property (nonatomic, strong) MSFFormsViewModel *formViewModel;

@property (nonatomic, copy) NSString *appNO;
@property (nonatomic, copy) NSString *appLmt;
@property (nonatomic, copy) NSString *applyStatus;
@property (nonatomic, copy) NSString *loanTerm;
@property (nonatomic, copy) NSString *loanPurpose;
@property (nonatomic, copy) NSString *jionLifeInsurance;
@property (nonatomic, copy) NSString *lifeInsuranceAmt;
@property (nonatomic, copy) NSString *loanFixedAmt;
@property (nonatomic, copy) NSString *productCd;

/**
 *	贷款目的
 */
@property (nonatomic, strong) MSFSelectKeyValues *purpose;
@property (nonatomic, strong, readonly) NSString *purposeText;

/**
 *	是否加入寿险计划
 */
@property (nonatomic, assign) BOOL insurance;

/**
 *	总金额
 */
@property (nonatomic, strong) NSString *totalAmount;
@property (nonatomic, copy) NSString *minMoney;
@property (nonatomic, copy) NSString *maxMoney;

@property (nonatomic, copy) MSFApplyCashModel *model;


@property (nonatomic, assign) id<MSFViewModelServices>services;

@property (nonatomic, strong, readonly) RACCommand *executeLifeInsuranceCommand;

@property (nonatomic, strong, readonly) RACCommand *executePurposeCommand;
@property (nonatomic, strong, readonly) RACCommand *executeTermCommand;

@property (nonatomic, strong) RACCommand *executeNextCommand;

- (instancetype)initWithViewModel:(MSFFormsViewModel *)viewModel;



@end
