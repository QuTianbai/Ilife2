//
// MSFAFRequestViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAFViewModel.h"

@class MSFMonths;
@class MSFSelectKeyValues;
@class RACCommand;

// 贷款申请入口－第一个界面
@interface MSFAFRequestViewModel : MSFAFViewModel

// 贷款期数对应的产品
@property(nonatomic,strong) MSFMonths *product;

/**
 *  总金额
 */
@property(nonatomic,assign) NSString *totalAmount;

/**
 *  贷款期数
 */
@property(nonatomic,strong) NSString *productTerms;

/**
 *  贷款目的
 */
@property(nonatomic,strong) MSFSelectKeyValues *purpose;

/**
 *  贷款每期还款额
 */
@property(nonatomic,assign) double termAmount;

/**
 *  是否加入寿险计划
 */
@property(nonatomic,assign) BOOL insurance;

// 是否同意贷款协议
@property(nonatomic,assign) BOOL agreeOnLicense;
@property(nonatomic,strong) RACCommand *executeAgreeOnLicense;

/**
 * 申请贷款
 */
@property(nonatomic,strong) RACCommand *executeRequest;
- (RACSignal *)requestValidSignal;

- (instancetype)initWithViewModel:(id)viewModel;

@end
