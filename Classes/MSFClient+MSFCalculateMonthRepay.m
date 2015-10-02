//
//  MSFClient+MSFCalculateMonthRepay.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFCalculateMonthRepay.h"
#import "MSFCalculatemMonthRepayModel.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (MSFCalculateMonthRepay)

- (RACSignal *)fetchCalculateMonthRepayWithAppLmt:(NSString *)appLmt AndLoanTerm:(NSString *)loanTerm AndProductCode:(NSString *)productCode AndJionLifeInsurance:(NSString *)jionLifeInsurance {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"loan/count" parameters:@{@"appLmt": appLmt, @"loanTerm": loanTerm, @"productCode": productCode, @"jionLifeInsurance": jionLifeInsurance}];
	
	return [[self enqueueRequest:request resultClass:MSFCalculatemMonthRepayModel.class] msf_parsedResults];
}

@end
