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
#import "MSFClient+Payment.h"
#import "MSFPayment.h"
#import "MSFOrderDetail.h"

static NSString *const MSFDrawCashViewModelErrorDomain = @"MSFDrawCashViewModelErrorDomain";

@interface MSFDrawCashViewModel ()

@property (nonatomic, assign) id<MSFViewModelServices>services;
@property (nonatomic, copy) NSString *contractNO;
@property (nonatomic, strong) NSString *enablemoney;

@property (nonatomic, strong) MSFOrderDetail *order;

@end

@implementation MSFDrawCashViewModel

- (instancetype)initWithModel:(MSFBankCardListModel *)model AndCirculateViewmodel:(id)viewModel AndServices:(id<MSFViewModelServices>)services AndType:(int)type {
	self = [super init];
	if (!self) {
		return  nil;
	}
	_smsCode = @"";
	_smsCode = @"";
	_smsSeqNo = @"";
	if (type == 2) {
		_repayFinanceViewModel = viewModel;
		_repayFinanceViewModel.type = type;
	} else if (type == 4) {
		_order = viewModel;
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
		RAC(self, enablemoney) = RACObserve(self, circulateViewModel.usableLimit);
		RAC(self, contractNO) = RACObserve(self, circulateViewModel.contractNo);
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
		RAC(self, contractNO) = RACObserve(self, repayFinanceViewModel.repaymentNumber);
	} else if (type == 0) {
		RAC(self, money) = [RACObserve(self, circulateViewModel.usableLimit) map:^id(NSString *value) {
			return [NSString stringWithFormat:@"剩余可用额度%@元", value];
		}];
		RAC(self, drawCash) = RACObserve(self, circulateViewModel.usableLimit);
		RAC(self, enablemoney) = RACObserve(self, circulateViewModel.usableLimit);
		RAC(self, contractNO) = RACObserve(self, circulateViewModel.contractNo);
	} else if (type == 4) {
		self.money = [NSString stringWithFormat:@"请支付首付金额¥%@", self.order.downPmt];
		self.drawCash = [NSString stringWithFormat:@"%@", self.order.downPmt];
		self.contractNO = self.order.inOrderId;
	}
	
	_bankCardNO = [model.bankCardNo substringFromIndex:model.bankCardNo.length - 4];
	
	
	_executeSubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self executeDrawCash];
	}];
	_executePayCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		if (self.smsCode.length == 0 || self.smsSeqNo.length == 0) return [RACSignal error:[NSError errorWithDomain:@"" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请输入正确的验证码"}]];
		return [self executePaySignal];
	}];
	
	_executSMSCommand = [[RACCommand alloc] initWithEnabled:
	[RACObserve(self, sending)
		map:^id(id value) {
			return @(![value boolValue]);
		}]
		signalBlock:^RACSignal *(id input) {
			return [self.services.httpClient sendSmsCodeForTrans];
		}];
	
	return self;
}

- (RACSignal *)executeDrawCash {
	NSError *error = nil;
	if (self.drawCash.length == 0 || [self.drawCash isEqualToString:@"0"] ) {
		NSString *errorStr = @"请输入提现金额";
		if (self.type == 1 || self.type == 2) {
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
		return [self.services.httpClient drawCashWithDrawCount:self.drawCash AndContraceNO:self.contractNO AndPwd:self.tradePWd AndType:self.type];
	}
	
	return [self.services.httpClient checkDataWithPwd:self.tradePWd contractNO:self.contractNO];
	
}

- (RACSignal *)executePaySignal {
	if (self.type == 4) {
		return [self.services.httpClient downPaymentWithPayment:self.order SMSCode:self.smsCode SMSSeqNo:self.smsSeqNo bankCardID:@""];
	}
	return [self.services.httpClient transActionWithAmount:self.drawCash smsCode:self.smsCode smsSeqNo:self.smsSeqNo contractNo:self.contractNO bankCardID:@"" transPwd:@""];
}

@end
