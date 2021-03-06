//
//  MSFDrawCashViewModel.m
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFRepaymentViewModel.h"
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
#import "MSFMyRepayDetailViewModel.h"
#import "MSFCirculateCashModel.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "NSString+Matches.h"

@interface MSFRepaymentViewModel ()

@property (nonatomic, strong, readwrite) NSString *bankIco;
@property (nonatomic, strong, readwrite) NSString *bankName;
@property (nonatomic, strong, readwrite) NSString *bankNo;
@property (nonatomic, strong, readwrite) NSString *uniqueTransactionID;
@property (nonatomic, strong, readwrite) NSString *captchaTitle;
@property (nonatomic, assign, readwrite) BOOL captchaWaiting;
@property (nonatomic, strong, readwrite) NSString *bankCardID;
@property (nonatomic, strong, readwrite) NSString *summary;

@end

@implementation MSFRepaymentViewModel

- (instancetype)initWithViewModel:(id)model services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_model = model;
	_services = services;
	
	_captcha = @"";
	_title = @"还款";
	_captchaWaiting = NO;
	_captchaTitle = @"获取验证码";
    
	_editable = NO;
    if ([model isKindOfClass:MSFCirculateCashModel.class] || [model isKindOfClass:[MSFMyRepayDetailViewModel class]]) {
        _editable = YES;
        
        if ([model isKindOfClass:[MSFMyRepayDetailViewModel class]] && ![((MSFMyRepayDetailViewModel *)model).type isEqualToString:@"信用钱包"]) {
             _editable = NO;
        }
        
    }
//    if ([self.debtAmounts floatValue] < 100) {
//        _editable = NO;
//    }
	@weakify(self)
	RAC(self, amounts) = [RACObserve(self, model) map:^id(id value) {
		if ([value isKindOfClass:MSFCirculateCashViewModel.class]) {
			MSFCirculateCashViewModel *viewModel = (MSFCirculateCashViewModel *)value;
			return viewModel.latestDueMoney;
		} else if ([value isKindOfClass:MSFRepaymentSchedulesViewModel.class]) {
			MSFRepaymentSchedulesViewModel *viewModel = (MSFRepaymentSchedulesViewModel *)value;
			return [@(viewModel.amount) stringValue];
        } else if ([value isKindOfClass:MSFMyRepayDetailViewModel.class]) {
            MSFMyRepayDetailViewModel *viewModel = (MSFMyRepayDetailViewModel *)value;
            if ([viewModel.type isEqualToString:@"信用钱包"]) {
                return @"";
            }
            return viewModel.latestDueMoney;
        }
		return @"";
	}];
	RAC(self, summary) = [RACObserve(self, model) map:^id(id value) {
		if ([value isKindOfClass:MSFCirculateCashModel.class]) {
			MSFCirculateCashViewModel *viewModel = (MSFCirculateCashViewModel *)value;
			return [NSString stringWithFormat:@"%@", viewModel.totalOverdueMoney];;
		} else if ([value isKindOfClass:MSFRepaymentSchedulesViewModel.class]) {
			MSFRepaymentSchedulesViewModel *viewModel = (MSFRepaymentSchedulesViewModel *)value;
			return [NSString stringWithFormat:@"本期最小还款金额￥%.2f,总欠款金额￥%@", viewModel.amount, viewModel.ownerAllMoney];;
		} else if ([value isKindOfClass:MSFMyRepayDetailViewModel.class]) {
			MSFMyRepayDetailViewModel *viewModel = (MSFMyRepayDetailViewModel *)value;
            if ([viewModel.type isEqualToString:@"信用钱包"]) {
                return [NSString stringWithFormat:@"%@", viewModel.totalOverdueMoney];
            }
			return [NSString stringWithFormat:@"%@", viewModel.latestDueMoney];
		}
		return @"";
	}];
	
	RAC(self, debtAmounts) = [RACObserve(self, model) map:^id(id value) {
		if ([value isKindOfClass:MSFCirculateCashModel.class]) {
			MSFCirculateCashViewModel *viewModel = (MSFCirculateCashViewModel *)value;
			return viewModel.totalOverdueMoney;
		} else if ([value isKindOfClass:MSFRepaymentSchedulesViewModel.class]) {
			MSFRepaymentSchedulesViewModel *viewModel = (MSFRepaymentSchedulesViewModel *)value;
			return viewModel.overdueMoney;
        } else if ([value isKindOfClass:MSFMyRepayDetailViewModel.class]) {
            //MSFMyRepayDetailViewModel *viewModel = (MSFMyRepayDetailViewModel *)value;
            return @"";
        }
		return @"";
	}];
    RAC(self, buttonTitle) = [RACObserve(self, model) map:^id(id value) {
        if ([value isKindOfClass:MSFMyRepayDetailViewModel.class]) {
            MSFMyRepayDetailViewModel *viewModel = (MSFMyRepayDetailViewModel *)value;
             NSDate *repayDate = [NSDateFormatter gmt1_dateFromString:viewModel.latestDueDate];
            return [NSString stringWithFormat:@"%@从主卡代扣", [NSDateFormatter msf_stringFromDate:repayDate]];
        }
        return @"";
    }];
     RAC(self, isOutTime) = [RACObserve(self, model) map:^id(id value) {
        if ([value isKindOfClass:MSFMyRepayDetailViewModel.class]) {
            MSFMyRepayDetailViewModel *viewModel = (MSFMyRepayDetailViewModel *)value;
            if ([viewModel.type isEqualToString:@"信用钱包"]) {
                return @YES;
            }
//            NSDate *nowdDate = [NSDate date];
//            NSDate *repayDate = [NSDateFormatter gmt1_dateFromString:viewModel.latestDueDate];
            if (![viewModel.contratStatus isEqualToString:@"已逾期"]) {
                return @NO;
            }
            
         }
         return @YES;
     }];
	
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
				self.bankCardID = x.bankCardId;
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
    self.amounts = self.summary;
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
	return [[self.services.httpClient sendSmsCodeForTrans] doNext:^(MSFPaymentToken *x) {
		@strongify(self)
		self.uniqueTransactionID = x.smsSeqNo;
	}];
}

- (RACSignal *)switchSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFBankCardListViewModel *viewModel = [[MSFBankCardListViewModel alloc] initWithServices:self.services type:@"1"];
		@weakify(self)
		[viewModel returnBanKModel:^(MSFBankCardListModel *model) {
			@strongify(self)
			self.bankCardID = model.bankCardId;
			self.bankName = model.bankName;
			self.bankNo = model.bankCardNo;
            self.bankIco = [MSFGetBankIcon getIconNameWithBankCode:model.bankCode];
		}];

		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)paymentValidSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self, captcha),
		RACObserve(self, uniqueTransactionID),
		RACObserve(self, amounts),
		RACObserve(self, debtAmounts),
	]
	reduce:^id(NSString *captcha , NSString *uniqueid, NSString *amounts) {
		return @(captcha.length > 0 && uniqueid.length > 0);
	}];
}

- (NSString *)contractNO {
	if ([self.model isKindOfClass:MSFCirculateCashModel.class]) {
		MSFCirculateCashViewModel *viewModel = (MSFCirculateCashViewModel *)self.model;
		return viewModel.contractNo;
	} else if ([self.model isKindOfClass:MSFRepaymentSchedulesViewModel.class]) {
		MSFRepaymentSchedulesViewModel *viewModel = (MSFRepaymentSchedulesViewModel *)self.model;
		return viewModel.repaymentNumber;
    } else if ([self.model isKindOfClass:MSFMyRepayDetailViewModel.class]) {
        MSFMyRepayDetailViewModel *viewModel = (MSFMyRepayDetailViewModel *)self.model;
        return viewModel.contractNo;
    }
	return @"";
}

- (RACSignal *)paymentSignal {
    if ([self.amounts rangeOfString:@"¥"].location != NSNotFound) {
        self.amounts = [self.amounts substringFromIndex:1];
    }
    if ([self.summary rangeOfString:@"¥"].location != NSNotFound) {
        self.summary = [self.summary substringFromIndex:1];
    }
    if ([self.amounts floatValue] > [self.summary floatValue]) {
       NSError *error = [NSError errorWithDomain:@"MSFProfessionalViewModelDomain" code:0 userInfo:@{
                                                                                             NSLocalizedFailureReasonErrorKey: @"还款金额不能大于欠款金额"
                                                                                             }];
        return [RACSignal error: error];
    }
    if (!self.amounts.isMoney) {
        NSError *error = [NSError errorWithDomain:@"MSFProfessionalViewModelDomain" code:0 userInfo:@{
                                                                                                      NSLocalizedFailureReasonErrorKey: @"还款金额格式不对"
                                                                                                      }];
        return [RACSignal error: error];
        
    }
	return [self.services.msf_gainPasscodeSignal
//		flattenMap:^RACStream *(id value) {
//			return [self.services.httpClient checkDataWithPwd:value contractNO:self.contractNO];
//		}]
		flattenMap:^RACStream *(id value) {
			return [self.services.httpClient transActionWithAmount:self.amounts smsCode:self.captcha smsSeqNo:self.uniqueTransactionID contractNo:self.contractNO bankCardID:self.bankCardID transPwd:value];
}];
}

@end
