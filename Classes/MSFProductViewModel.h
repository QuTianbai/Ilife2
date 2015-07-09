//
// MSFProductViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@class MSFMonths;
@class MSFSelectKeyValues;
@class RACCommand;
@class MSFFormsViewModel;
@class MSFCheckEmployee;

// 贷款申请入口－第一个界面
@interface MSFProductViewModel : RVMViewModel

@property(nonatomic,readonly) MSFFormsViewModel *formsViewModel;

@property(nonatomic,strong,readonly) MSFCheckEmployee *market;

// 贷款期数对应的产品
@property(nonatomic,strong) MSFMonths *product;
@property(nonatomic,strong) MSFMonths *productTitle;

/**
 *  总金额
 */
@property(nonatomic,strong) NSString *totalAmount;
@property(nonatomic,strong,readonly) NSString *totalAmountPlacholder;

/**
 *  贷款期数
 */
@property(nonatomic,strong) NSString *productTerms;

/**
 *  贷款目的
 */
@property(nonatomic,strong) MSFSelectKeyValues *purpose;
@property(nonatomic,strong,readonly) NSString *purposeText;

/**
 *  贷款每期还款额
 */
@property(nonatomic,assign) double termAmount;
@property(nonatomic,strong,readonly) NSString *termAmountText;

/**
 *  是否加入寿险计划
 */
@property(nonatomic,assign) BOOL insurance;

/**
 * 申请贷款
 */
@property(nonatomic,strong,readonly) RACCommand *executeRequest;

- (instancetype)initWithFormsViewModel:(id)viewModel;

@end
