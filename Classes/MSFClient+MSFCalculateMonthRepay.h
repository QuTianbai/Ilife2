//
//  MSFClient+MSFCalculateMonthRepay.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFCalculateMonthRepay)

// 通过用户输入的总额，计算每月还款金额.
//
// appLmt            - 贷款的总额.
// loanTerm          - 期数.
// productCode       - 产品代码.
// jionLifeInsurance - 是否加入寿险计划 1 加入 0 非加入.
//
// Returns a signal which will send a MSFCalculatemMonthRepayModel.
- (RACSignal *)fetchCalculateMonthRepayWithAppLmt:(NSString *)appLmt AndLoanTerm:(NSString *)loanTerm AndProductCode:(NSString *)productCode AndJionLifeInsurance:(NSString *)jionLifeInsurance;

@end
