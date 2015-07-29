//
// MSFProductViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class MSFProduct;
@class MSFSelectKeyValues;
@class RACCommand;
@class MSFFormsViewModel;
@class MSFMarket;

// 贷款申请入口－第一个界面
@interface MSFProductViewModel : RVMViewModel

@property (nonatomic, weak, readonly) MSFFormsViewModel *formsViewModel;

@property (nonatomic, weak, readonly) MSFMarket *market;

// 贷款期数对应的产品
@property (nonatomic, strong) MSFProduct *product;
@property (nonatomic, strong) MSFProduct *productTitle;

/**
 *	总金额
 */
@property (nonatomic, strong) NSString *totalAmount;
@property (nonatomic, copy) NSString *minMoney;
@property (nonatomic, copy) NSString *maxMoney;
@property (nonatomic, strong, readonly) NSString *totalAmountPlacholder;

/**
 *	贷款期数
 */
@property (nonatomic, strong) NSString *productTerms;

/**
 *	贷款目的
 */
@property (nonatomic, strong) MSFSelectKeyValues *purpose;
@property (nonatomic, strong, readonly) NSString *purposeText;

/**
 *	贷款每期还款额
 */
@property (nonatomic, assign) double termAmount;
@property (nonatomic, strong, readonly) NSString *termAmountText;

/**
 *	是否加入寿险计划
 */
@property (nonatomic, assign) BOOL insurance;

@property (nonatomic, strong, readonly) RACCommand *executeLifeInsuranceCommand;
@property (nonatomic, strong, readonly) RACCommand *executePurposeCommand;
@property (nonatomic, strong, readonly) RACCommand *executeTermCommand;
@property (nonatomic, strong, readonly) RACCommand *executeNextCommand;

- (instancetype)initWithFormsViewModel:(id)viewModel;

@end
