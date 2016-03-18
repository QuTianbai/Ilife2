//
//  MSFWithDrawViewModel.m
//  Finance
//
//  Created by xbm on 16/3/1.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFWithDrawViewModel.h"
#import "MSFDrawModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFWithDrawViewModel ()

@property (nonatomic, strong) MSFDrawModel *model;

@end

@implementation MSFWithDrawViewModel

- (instancetype)initWithModel:(id)model {
	self = [super init];
	if (!self) {
		return nil;
	}
	_model = model;
	_bankCardNo = @"";
	_bankName = @"";
	_bankCode = @"";
	_withdrawDate = @"";
	_withdrawMoney = @"";
	RAC(self, bankCardNo) = [RACObserve(self, model.bankCardNo) ignore:nil];
	RAC(self, bankName) = [RACObserve(self, model.bankName) ignore:nil];
	RAC(self, bankCode) = [RACObserve(self, model.bankCode) ignore:nil];
	RAC(self, withdrawDate) = [RACObserve(self, model.withdrawDate) ignore:nil];
	RAC(self, withdrawMoney) = [RACObserve(self, model.withdrawMoney) ignore:nil];
	
	return self;
}

@end
