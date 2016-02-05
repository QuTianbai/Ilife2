//
//  MSFDrawCashViewModel.m
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFDrawingsViewModel.h"
#import "MSFGetBankIcon.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFClient+Users.h"
#import "MSFRepaymentSchedulesViewModel.h"
#import "MSFClient+Payment.h"
#import "MSFPayment.h"
#import "MSFOrderDetail.h"
#import "MSFGetBankIcon.h"
#import "MSFClient+Users.h"
#import "MSFClient+Payment.h"
#import "MSFClient+BankCardList.h"
#import "MSFOrderDetail.h"
#import "MSFBankCardListModel.h"
#import "MSFPaymentToken.h"
#import "MSFBankCardListViewModel.h"
#import "MSFCirculateCashViewModel.h"

@interface MSFDrawingsViewModel ()

@property (nonatomic, strong, readwrite) NSString *bankIco;
@property (nonatomic, strong, readwrite) NSString *bankName;
@property (nonatomic, strong, readwrite) NSString *bankNo;
@property (nonatomic, strong, readwrite) NSString *uniqueTransactionID;
@property (nonatomic, strong, readwrite) NSString *captchaTitle;
@property (nonatomic, assign, readwrite) BOOL captchaWaiting;

@end

@implementation MSFDrawingsViewModel

- (instancetype)initWithViewModel:(id)model services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_model = model;
	_services = services;
	
	_captcha = @"";
	_title = @"提款";
	_captchaWaiting = NO;
	_captchaTitle = @"获取验证码";
	
	_editable = YES;
	
	RAC(self, amounts) = [RACObserve(self, model) map:^id(id value) {
		if ([value isKindOfClass:MSFCirculateCashViewModel.class]) {
			MSFCirculateCashViewModel *viewModel = (MSFCirculateCashViewModel *)value;
			return viewModel.usableLimit;
		}
		return @"";
	}];
	RAC(self, summary) = [RACObserve(self, model) map:^id(id value) {
		if ([value isKindOfClass:MSFCirculateCashViewModel.class]) {
			MSFCirculateCashViewModel *viewModel = (MSFCirculateCashViewModel *)value;
			return [NSString stringWithFormat:@"剩余可用额度%@元", viewModel.usableLimit];
		}
		return @"";
	}];
	
	@weakify(self)
	[self.didBecomeActiveSignal subscribeNext:^(id x) {
		@strongify(self)
		[[[self.services.httpClient fetchBankCardList]
			filter:^BOOL(MSFBankCardListModel *value) {
				return value.master;
			}]
			subscribeNext:^(MSFBankCardListModel *x) {
				self.bankIco = [MSFGetBankIcon getIconNameWithBankCode:x.bankCode];
				self.bankNo = x.bankCardNo;
				self.bankName = x.bankName;
			}];
		RAC(self, supports) = [self.services.httpClient fetchSupportBankInfo];
	}];
	
	_executeCaptchaCommand = [[RACCommand alloc] initWithEnabled:self.captchaValidSignal signalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [[self captchaSignal] doNext:^(id x) {
			self.captchaWaiting = YES;
			RACSignal *repetitiveEventSignal = [[[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:60] takeUntil:self.didBecomeInactiveSignal];
			__block int repetCount = 60;
			[repetitiveEventSignal subscribeNext:^(id x) {
				self.captchaTitle = [@(--repetCount) stringValue];
			} completed:^{
				self.captchaTitle = @"获取验证码";
				self.captchaWaiting = NO;
			}];
		}];
	}];
	
	_executeSwitchCommand = [[RACCommand alloc] initWithEnabled:[RACSignal return:@YES] signalBlock:^RACSignal *(id input) {
		return [self switchSignal];
	}];
	
	_executePaymentCommand = [[RACCommand alloc] initWithEnabled:self.paymentValidSignal signalBlock:^RACSignal *(id input) {
		return [self paymentSignal];
	}];
	
  return self;
}

#pragma mark - Private

- (RACSignal *)captchaValidSignal {
	return RACSignal.empty;
}

- (RACSignal *)captchaSignal {
	return RACSignal.empty;
}

- (RACSignal *)switchSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFBankCardListViewModel *viewModel = [[MSFBankCardListViewModel alloc] initWithServices:self.services];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)paymentValidSignal {
	return [RACSignal combineLatest:@[RACObserve(self, model), RACObserve(self, amounts)]
		reduce:^id(MSFCirculateCashViewModel *viewModel, NSString *amounts) {
			return @(amounts.doubleValue <= viewModel.usableLimit.doubleValue);
		}];
}

- (NSString *)contractNO {
	if ([self.model isKindOfClass:MSFCirculateCashViewModel.class]) {
		MSFCirculateCashViewModel *viewModel = (MSFCirculateCashViewModel *)self.model;
		return viewModel.contractNo;
	} else if ([self.model isKindOfClass:MSFRepaymentSchedulesViewModel.class]) {
		MSFRepaymentSchedulesViewModel *viewModel = (MSFRepaymentSchedulesViewModel *)self.model;
		return viewModel.repaymentNumber;
	}
	return @"";
}

- (RACSignal *)paymentSignal {
	return [self.services.msf_gainPasscodeSignal
		flattenMap:^RACStream *(id value) {
			return [self.services.httpClient drawingsWithAmounts:self.amounts contractNo:self.contractNO passcode:value];
		}];
}

@end
