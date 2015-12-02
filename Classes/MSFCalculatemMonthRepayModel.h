//
//  MSFCalculatemMonthRepayModel.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

// 通过接口计算的每月还款金额
@interface MSFCalculatemMonthRepayModel : MSFObject

// 固定贷款每月还款金额
@property (nonatomic, copy, readonly) NSString *loanFixedAmt;

// 寿险计划金额
@property (nonatomic, copy, readonly) NSString *lifeInsuranceAmt;

@end
