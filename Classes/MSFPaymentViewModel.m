//
//  MSFDrawCashViewModel.m
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFPaymentViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFGetBankIcon.h"
#import "MSFClient+Users.h"
#import "MSFClient+Payment.h"
#import "MSFClient+MSFBankCardList.h"
#import "MSFOrderDetail.h"
#import "MSFBankCardListModel.h"
#import "MSFTransSmsSeqNOModel.h"
#import "MSFBankCardListViewModel.h"

@interface MSFPaymentViewModel ()

@property (nonatomic, strong, readwrite) NSString *bankIco;
@property (nonatomic, strong, readwrite) NSString *bankName;
@property (nonatomic, strong, readwrite) NSString *bankNo;
@property (nonatomic, strong, readwrite) NSString *uniqueTransactionID;
@property (nonatomic, strong, readwrite) NSString *captchaTitle;
@property (nonatomic, assign, readwrite) BOOL captchaWaiting;

@end

@implementation MSFPaymentViewModel

- (instancetype)initWithModel:(MSFOrderDetail *)model services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_model = model;
	_services = services;
	
	_captcha = @"";
	_title = @"首付支付";
	_captchaWaiting = NO;
	_captchaTitle = @"获取验证码";
	
	_editable = NO;
	
	RAC(self, amounts) = RACObserve(self, model.downPmt);
	RAC(self, summary) = [RACObserve(self, model.downPmt) map:^id(id value) {
		return [NSString stringWithFormat:@"请支付首付金额¥%@", value];
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
	return [RACObserve(self, captchaWaiting) map:^id(id value) {
		return @(![value boolValue]);
	}];
}

- (RACSignal *)captchaSignal {
	@weakify(self)
	return [[self.services.httpClient sendSmsCodeForTrans] doNext:^(MSFTransSmsSeqNOModel *x) {
		@strongify(self)
		self.uniqueTransactionID = x.smsSeqNo;
	}];
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
	return [RACSignal combineLatest:@[
		RACObserve(self, captcha),
		RACObserve(self, uniqueTransactionID),
	]
	reduce:^id(NSString *captcha , NSString *uniqueid) {
		return @(captcha.length > 0 && uniqueid.length > 0);
	}];
}

- (RACSignal *)paymentSignal {
	return [[[self.services msf_gainPasscodeSignal] flattenMap:^RACStream *(id value) {
		return [self.services.httpClient checkDataWithPwd:value contractNO:self.model.inOrderId];
	}] flattenMap:^RACStream *(id value) {
		return [self.services.httpClient downPaymentWithPayment:self.model SMSCode:self.captcha SMSSeqNo:self.uniqueTransactionID];
	}];
}

@end
