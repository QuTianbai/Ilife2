//
//  MSFApplyCashModel.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFApplyCashModel.h"

@implementation MSFApplyCashModel

- (id)init {
	self = [super init];
	if (!self) {
		return nil;
	}
	_appNo = @"";
	_appLmt = @"";
	_applyStatus = 0;
	_loanTerm = @"";
	_loanPurpose = @"";
	_lifeInsuranceAmt = @"";
	_jionLifeInsurance = @"";
	_loanFixedAmt = @"";
	_productCd = @"";
	return self;
}

@end
