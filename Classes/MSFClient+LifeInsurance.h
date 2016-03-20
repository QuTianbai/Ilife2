//
//  MSFClient+MSFLifeInsurance.h
//  Finance
//
//  Created by xbm on 15/10/13.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@class MSFLoanType;

@interface MSFClient (LifeInsurance)

- (RACSignal *)fetchLifeInsuranceAgreementWithProductType:(NSString *)product __deprecated_msg("Use `-fetchLifeInsuranceAgreementWithLoanType:` instead");

// 获取寿险协议.
//
// Returns a signal which will send a NSURLRequest
- (RACSignal *)fetchLifeInsuranceAgreementWithLoanType:(MSFLoanType *)loanType;

@end
