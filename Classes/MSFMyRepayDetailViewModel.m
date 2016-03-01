//
//  MSFMyRepayDetailViewModel.m
//  Finance
//
//  Created by xbm on 16/3/1.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyRepayDetailViewModel.h"
#import "MSFMyRepayDetailModel.h"

@interface MSFMyRepayDetailViewModel ()

@property (nonatomic, assign) id<MSFViewModelServices> services;
@property (nonatomic, strong) MSFMyRepayDetailModel *model;

@end

@implementation MSFMyRepayDetailViewModel

-(instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) {
		return nil;
	}
	_services = services;
	_contractNo = @"";
	_latestDueMoney = @"";
	_latestDueDate = @"";
	_type = @"";
	_appLmt = @"";
	_loanTerm = @"";
	_loanCurrTerm = @"";
	_loanExpireDate = @"";
	_totalOverdueMoney = @"";
	_interest = @"";
	_applyDate = @"";
	_cmdtyList = @[];
	_withdrawList = @[];
	
	
	
	return self;
}

@end
