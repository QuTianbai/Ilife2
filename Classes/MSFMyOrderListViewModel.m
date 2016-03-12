//
//  MSFMyOrderListViewModel.m
//  Finance
//
//  Created by xbm on 16/3/2.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderListViewModel.h"
#import "MSFOrder.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "NSDictionary+MSFKeyValue.h"

@interface MSFMyOrderListViewModel ()

@property (nonatomic, strong) MSFOrder *model;

@end

@implementation MSFMyOrderListViewModel

- (instancetype)initWithModel:(id)model {
	self = [super init];
	if (!self) {
		return nil;
	}
	_model = model;
	_contractTitile = @"";
	_contractSubTitile = @"";
	_applyType = @"";
	_appLmt = @"";
	_applyTime = @"";
	_loanTerm = @"";
	_status = @"";
	_appNo = @"";
	_loanFixedAmt = @"";
	_loanPurpose = @"";
	_bankCardNo = @"";
	_jionLifeInsurance = @"";
	_monthMoney = @"";
	
	RAC(self, contractImg) = [RACObserve(self, model.type) map:^id(NSString *value) {
		return [NSDictionary imageForContractKey:value];
	}];
	RAC(self, contractTitile) = [RACObserve(self, model.type) map:^id(id value) {
		return [NSDictionary typeStringForKey:value];
	}];
	RAC(self, contractSubTitile) = [[RACObserve(self, model) ignore:nil] map:^id(MSFOrder *value) {
		return [NSString stringWithFormat:@"¥%@ 分%@期", value.appLmt, value.loanTerm];
	}];
	
	RAC(self, applyType) = [RACObserve(self, model.type) ignore:nil];
	RAC(self, applyTime) = [RACObserve(self, model.applyTime) ignore:nil];
	RAC(self, appLmt) = [RACObserve(self, model.appLmt) ignore:nil];
	RAC(self, loanTerm) = [RACObserve(self, model.loanTerm) ignore:nil];
	RAC(self, status) = [RACObserve(self, model.status) ignore:nil];
	RAC(self, appNo) = [RACObserve(self, model.appNo) ignore:nil];
	RAC(self, loanFixedAmt) = [RACObserve(self, model.loanFixedAmt) ignore:nil];
	RAC(self, loanPurpose) = [RACObserve(self, model.loanPurpose) ignore:nil];
	RAC(self, bankCardNo) = [RACObserve(self, model.bankCardNo) ignore:nil];
	RAC(self, jionLifeInsurance) = [RACObserve(self, model.jionLifeInsurance) ignore:nil];
	RAC(self, monthMoney) = [[RACObserve(self, model) ignore:nil] map:^id(MSFOrder *value) {
		if (value.loanFixedAmt.length == 0 || value.loanTerm.length == 0) {
			return @"";
		}
		return [NSString stringWithFormat:@"¥%@×%@期", value.loanFixedAmt, value.loanTerm];
	}];
	
	return self;
}

@end
