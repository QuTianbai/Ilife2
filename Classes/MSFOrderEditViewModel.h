//
//  MSFOrderEditViewModel.h
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class RACCommand;

@interface MSFOrderEditViewModel : RVMViewModel

@property (nonatomic, weak) id<MSFViewModelServices>services;

@property (nonatomic, strong, readonly) NSString *downPmtPct; // 首付比例
@property (nonatomic, strong, readonly) NSString *downPmtAmt; // 首付金额
@property (nonatomic, strong, readonly) NSString *loanAmt; // 分期总金额
@property (nonatomic, strong, readonly) NSArray *loanTerms; // 贷款期数
@property (nonatomic, assign, readonly) BOOL joinInsurance; // 是否加入寿险计划
@property (nonatomic, strong, readonly) NSString *insurance; // 寿险金额
@property (nonatomic, strong, readonly) NSString *trialAmt; // 试算每期还款金额
@property (nonatomic, strong, readonly) NSArray *commodities; // 商品列表

@property (nonatomic, strong, readonly) RACCommand *executeDownPmtPctCommand;
@property (nonatomic, strong, readonly) RACCommand *executeInsuranceCommand;

- (instancetype)initWithOrderId:(NSString *)orderId
											 services:(id<MSFViewModelServices>)services;
- (NSString *)reuseIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath;

@end
