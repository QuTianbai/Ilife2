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
#import "MSFClient+Users.h"
#import "MSFRepaymentSchedulesViewModel.h"

static NSString *const MSFDrawCashViewModelErrorDomain = @"MSFDrawCashViewModelErrorDomain";

@interface MSFDrawCashViewModel ()

@property (nonatomic, assign) id<MSFViewModelServices>services;
@property (nonatomic, copy) NSString *contractNO;
@property (nonatomic, assign) NSString *enablemoney;
@property (nonatomic, assign, readwrite) int type;
@property (nonatomic, strong) MSFRepaymentSchedulesViewModel *repayFinanceViewModel;

@end

@implementation MSFDrawCashViewModel

- (instancetype)initWithModel:(MSFBankCardListModel *)model AndCirculateViewmodel:(id)viewModel AndServices:(id<MSFViewModelServices>)services AndType:(int)type {
	self = [super init];
	if (!self) {
		return  nil;
	}
	if (type == 2) {
		_repayFinanceViewModel = viewModel;
	} else {
		_circulateViewModel = viewModel;
	}
	_type = type;
	_services = services;
	_bankIcon = [MSFGetBankIcon getIconNameWithBankCode:model.bankCode];
	_bankName = model.bankName;
	
	if (type == 1) {
		RAC(self, money) = [RACSignal combineLatest:@[
				RACObserve(self, circulateViewModel.latestDueMoney),
				RACObserve(self, circulateViewModel.totalOverdueMoney)]
			reduce:^id(NSString *lastDueMoney, NSString *totaloverdueMoney){
				if (lastDueMoney == nil) {
					lastDueMoney = @"0";
				}
				if (totaloverdueMoney == nil) {
					totaloverdueMoney = @"0";
				}
				return [NSString stringWithFormat:@"本期最小还款金额￥%@,总欠款金额￥%@", lastDueMoney, totaloverdueMoney];
			}];
		
		RAC(self, drawCash) = RACObserve(self, circulateViewModel.latestDueMoney);
	} else if (type == 2) {
		RAC(self, money) = [RACSignal combineLatest:@[
																									RACObserve(self, repayFinanceViewModel.amount),
																									RACObserve(self, repayFinanceViewModel.ownerAllMoney)]
																				 reduce:^id(NSString *lastDueMoney, NSString *totaloverdueMoney){
																					 if (lastDueMoney == nil) {
																						 lastDueMoney = @"0";
																					 }
																					 if (totaloverdueMoney == nil) {
																						 totaloverdueMoney = @"0";
																					 }
																					 return [NSString stringWithFormat:@"本期应还款金额￥%@,总欠款金额￥%@", lastDueMoney, totaloverdueMoney];
																				 }];
		
		RAC(self, drawCash) = RACObserve(self, repayFinanceViewModel.amount);
	}else {
		RAC(self, money) = [RACObserve(self, circulateViewModel.usableLimit) map:^id(NSString *value) {
			return [NSString stringWithFormat:@"剩余可用额度%@元", value];
		}];
		RAC(self, drawCash) = RACObserve(self, circulateViewModel.usableLimit);
	}
	
	_bankCardNO = [model.bankCardNo substringFromIndex:model.bankCardNo.length - 4];
	RAC(self, enablemoney) = RACObserve(self, circulateViewModel.usableLimit);
	RAC(self, contractNO) = RACObserve(self, circulateViewModel.contractNo);
	
	_executeSubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self executeDrawCash];
	}];
	
	return self;
}

- (RACSignal *)executeDrawCash {
	NSError *error = nil;
	if (self.drawCash.length == 0 || [self.drawCash isEqualToString:@"0"] ) {
		NSString *errorStr = @"请输入提现金额";
		if (self.type == 1) {
			errorStr = @"请输入还款金额";
		}
		error = [NSError errorWithDomain:MSFDrawCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: errorStr, }];
		return [RACSignal error:error];
	}
	
	NSArray *moneyArray = [self.drawCash componentsSeparatedByString:@"."];
	if (moneyArray.count >= 2) {
		if (((NSString *)moneyArray[1]).length >2) {
			error = [NSError errorWithDomain:MSFDrawCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"金额小数不可超过2位，请重新填写", }];
			return [RACSignal error:error];
		}
		
	}
	if ([(NSString *)moneyArray[0] isEqualToString:@""]) {
		error = [NSError errorWithDomain:MSFDrawCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"金额输入错误，请重新填写", }];
		return [RACSignal error:error];
	}
	
	if (self.type == 0) {
		if (self.drawCash.intValue > self.enablemoney.intValue) {
			error = [NSError errorWithDomain:MSFDrawCashViewModelErrorDomain code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"超出最大额度限制，请重新填写", }];
			return [RACSignal error:error];
		}
	}
	
	return [self.services.httpClient drawCashWithDrawCount:self.drawCash AndContraceNO:self.contractNO AndPwd:self.tradePWd AndType:self.type];
}

@end
