//
//  MSFCartViewModel.h
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFCart;
@class MSFMarkets;
@class MSFLoanType;

@interface MSFCartViewModel : RVMViewModel

// 页面展示数据
@property (nonatomic, strong, readonly) NSString *downPmtAmt; // 首付金额
@property (nonatomic, strong, readonly) NSString *loanAmt;    // 贷款金额
@property (nonatomic, strong, readonly) NSString *insurance;  // 寿险金额
@property (nonatomic, strong, readonly) NSString *trialAmt;   // 试算每期还款金额
@property (nonatomic, assign, readonly) BOOL joinInsurance; // 是否加入寿险计划
@property (nonatomic, strong, readonly) NSArray *commodities; // 商品列表
@property (nonatomic, strong, readonly) NSArray *terms; // 产品群信息
@property (nonatomic, strong) NSString *term;				// 贷款期数, 外部可以修改

@property (nonatomic, weak, readonly) id<MSFViewModelServices>services;
@property (nonatomic, strong, readonly) MSFLoanType *loanType; // 产品群Id 3101
@property (nonatomic, strong, readonly) MSFCart *cart;
@property (nonatomic, strong, readonly) RACCommand *executeInsuranceCommand; //查看保险协议

- (instancetype)initWithCartId:(NSString *)cartId services:(id<MSFViewModelServices>)services;
- (NSString *)reuseIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath;

@end
