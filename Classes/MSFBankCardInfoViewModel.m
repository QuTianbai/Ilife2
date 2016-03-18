//
//  MSFBankCardInfoViewModel.m
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFBankCardInfoViewModel.h"

@implementation MSFBankCardInfoViewModel

- (instancetype)initWithServices:(id<MSFViewModelServices>)servers {
	self = [super init];
	if (!self) {
		return nil;
	}
	_bankCardId = @"";
	_bankCardNo = @"";
	_bankCardType = @"";
	_bankName = @"";
	_bankBranchCityCode = @"";
	_bankBranchProvinceCode = @"";
	
	return self;
}

@end
