//
//  MSFClient+MSFCalculateMonthRepay.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFCalculateMonthRepay)

- (RACSignal *)fetchCalculateMonthRepayWithAppLmt:(NSString *)appLmt AndLoanTerm:(NSString *)loanTerm AndProductCode:(NSString *)productCode AndJionLifeInsurance:(NSString *)jionLifeInsurance;

@end
