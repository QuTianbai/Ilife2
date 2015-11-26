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
@class MSFMarkets;
@class MSFTeam;

@interface MSFApplyCashVIewModel : RVMViewModel <MSFApplicationViewModel>

@property (nonatomic, strong) NSString *applicationNo;

@property (nonatomic, strong) MSFFormsViewModel *formViewModel;

@property (nonatomic, copy) NSString *appNO;
@property (nonatomic, copy) NSString *appLmt; // 贷款金额
@property (nonatomic, copy) NSString *applyStatus;
@property (nonatomic, copy) NSString *loanTerm; // 贷款期数
@property (nonatomic, copy) NSString *loanPurpose;
@property (nonatomic, copy) NSString *jionLifeInsurance;
@property (nonatomic, copy) NSString *lifeInsuranceAmt;
@property (nonatomic, copy) NSString *loanFixedAmt;
@property (nonatomic, copy) NSString *productCd;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *accessories;

/**
 *	贷款目的
 */
@property (nonatomic, strong) MSFSelectKeyValues *purpose;
@property (nonatomic, strong, readonly) NSString *purposeText;

/**
 *	金额
 */
@property (nonatomic, copy) NSString *minMoney;
@property (nonatomic, copy) NSString *maxMoney;

// 贷款期数对应的产品
@property (nonatomic, strong) MSFTeam *product;

@property (nonatomic, copy) MSFApplyCashModel *model;

@property (nonatomic, strong) MSFMarkets *markets;

@property (nonatomic, assign) id<MSFViewModelServices>services;

@property (nonatomic, strong, readonly) RACCommand *executeLifeInsuranceCommand;

@property (nonatomic, strong, readonly) RACCommand *executePurposeCommand;
@property (nonatomic, strong, readonly) RACCommand *executeTermCommand;

@property (nonatomic, strong) RACCommand *executeNextCommand;
@property (nonatomic, strong) RACCommand *executeAllowMSCommand __deprecated;
@property (nonatomic, strong) RACCommand *executeAllowMLCommand __deprecated;

@property (nonatomic, copy) NSString *masterBankCardNameAndNO;
@property (nonatomic, strong) NSString *productID;

- (instancetype)initWithViewModel:(MSFFormsViewModel *)viewModel __deprecated;
- (instancetype)initWithViewModel:(MSFFormsViewModel *)viewModel productType:(NSString *)productType;

- (RACSignal *)submitSignalWithStatus:(NSString *)status;

- (RACSignal *)fetchProductType __deprecated;

@end
