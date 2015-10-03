//
//  MSFDrawCashViewModel.m
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFDrawCashViewModel.h"
#import "MSFGetBankIcon.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient.h"

static NSString *const MSFDrawCashViewModelErrorDomain = @"MSFDrawCashViewModelErrorDomain";

@interface MSFDrawCashViewModel ()

@property (nonatomic, assign) id<MSFViewModelServices>services;

@property (nonatomic, copy) NSString *contractNO;

@property (nonatomic, assign) int enablemoney;

@property (nonatomic, assign) int type;

@end

@implementation MSFDrawCashViewModel

- (instancetype)initWithModel:(MSFBankCardListModel *)model AndCirculateViewmodel:(MSFCirculateCashViewModel *)viewModel AndServices:(id<MSFViewModelServices>)services AndType:(int)type {
	self = [super init];
	if (!self) {
		return  nil;
	}
	_type = type;
	_services = services;
	_bankIcon = [MSFGetBankIcon getIconNameWithBankCode:model.bankCode];
	_bankName = model.bankName;
	
	_money = [NSString stringWithFormat:@"剩余可用额度%@元", viewModel.usableLimit];
	self.drawCash = viewModel.usableLimit;
	
	if (type == 1) {
		_money = [NSString stringWithFormat:@"本期最小还款金额￥%@,总欠款金额￥%@", viewModel.latestDueMoney, viewModel.totalOverdueMoney];
		self.drawCash = viewModel.latestDueMoney;
	}
	
	_enablemoney = viewModel.usableLimit.intValue;
	_bankCardNO = [model.bankCardNo substringFromIndex:model.bankCardNo.length - 4];
	_contractNO = viewModel.contractNo;
	
	
	
	_executeSubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self executeDrawCash];
	}];
	
	return self;
}

- (RACSignal *)executeDrawCash {
	NSError *error = nil;
	if (self.drawCash.length == 0 ) {
		error = [NSError errorWithDomain:MSFDrawCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请输入提现金额", }];
		return [RACSignal error:error];
	}
	if (self.type == 0) {
		if (self.drawCash.intValue > self.enablemoney) {
			error = [NSError errorWithDomain:MSFDrawCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"超出最大额度限制，请重新填写", }];
			return [RACSignal error:error];
		}
	}
	
	return [self.services.httpClient drawCashWithDrawCount:self.drawCash AndContraceNO:self.contractNO AndType:self.type];
}

@end
