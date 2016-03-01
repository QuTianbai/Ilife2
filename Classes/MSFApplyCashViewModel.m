//
//  MSFApplyCashVIewModel.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFApplyCashViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFApplyCashModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCalculatemMonthRepayModel.h"
#import "MSFClient+CalculateMonthRepay.h"
#import "MSFResponse.h"
#import "MSFMarkets.h"
#import "MSFSelectionViewModel.h"
#import "MSFWebViewModel.h"
#import "MSFTeam.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFClient+CheckAllowApply.h"
#import "MSFCheckAllowApply.h"
#import "MSFApplyCashInfo.h"
#import "MSFLoanAgreementViewModel.h"
#import "MSFClient+SubmitAppyCash.h"
#import "MSFBankCardListModel.h"
#import "MSFLifeInsuranceViewModel.h"
#import "MSFClient+Agreements.h"
#import "MSFUser.h"
#import "MSFClient+ProductType.h"
#import "MSFClient+CirculateCash.h"
#import "MSFCirculateCashModel.h"
#import "MSFLoanType.h"

@interface MSFApplyCashViewModel ()

@property (nonatomic, copy) MSFCalculatemMonthRepayModel *calculateModel;

@end

@implementation MSFApplyCashViewModel

- (instancetype)initWithViewModel:(MSFFormsViewModel *)viewModel loanType:(MSFLoanType *)loanType {
	self = [super init];
	if (!self) {
		return nil;
	}
	_formViewModel = viewModel;
	_loanType = loanType;
	[self initialize];
	
	return self;
}

#pragma mark - Private

- (void)initialize {
	_model = [[MSFApplyCashModel alloc] init];
	_services = self.formViewModel.services;
	_model.productCd = self.loanType.typeID;
	_jionLifeInsurance = @"";
	_appNO = @"";
	_applicationNo = @"";
	_array = [[NSArray alloc] init];
	
	RACChannelTo(self, applicationNo) = RACChannelTo(self, appNO);
	RACChannelTo(self, accessories) = RACChannelTo(self, array);
	
	RAC(self, masterBankCardNameAndNO) = RACObserve(self, formViewModel.masterbankInfo);
	RAC(self, model.appNo) = RACObserve(self, appNO);
	RAC(self, model.appLmt) = RACObserve(self, appLmt);
	
	RAC(self, model.jionLifeInsurance) = RACObserve(self, jionLifeInsurance);
	RAC(self, model.lifeInsuranceAmt) = [RACObserve(self, lifeInsuranceAmt) map:^id(NSString *value) {
		if (value == nil || [value isEqualToString:@""]) {
			return @"0.00";
		}
		return value;
	}];
	RAC(self, model.loanFixedAmt) = RACObserve(self, loanFixedAmt);
	
	RAC(self, minMoney) = RACObserve(self, formViewModel.markets.allMinAmount);
	RAC(self, maxMoney) = RACObserve(self, formViewModel.markets.allMaxAmount);
	
	RAC(self, model.loanPurpose) = [RACObserve(self, purpose) map:^id(MSFSelectKeyValues *value) {
		self.loanPurpose = value.code;
		return value.code;
	}];
	
	RAC(self, purposeText) = [RACObserve(self, purpose) map:^id(id value) {
		return [value text];
	}];
	
	RAC(self, markets) = [RACObserve(self, formViewModel.markets) map:^id(id value) {
		return value;
	}];
	@weakify(self)
	[RACObserve(self, product) subscribeNext:^(MSFTeam *product) {
		@strongify(self)
		self.loanTerm = self.product.loanTeam;
		self.model.loanTerm = product.loanTeam;
	}];

	RAC(self, calculateModel) = [[RACSignal
		combineLatest:@[
			RACObserve(self, appLmt),
			RACObserve(self, loanTerm),
			RACObserve(self, jionLifeInsurance)
		]]
		flattenMap:^RACStream *(RACTuple *productAndInsurance) {
			RACTupleUnpack(NSString *appLmt, NSString *loanTerm, NSString *jionLifeInsurance) = productAndInsurance;
			if (!loanTerm) {
				return [RACSignal return:@0];
			}
			return [[[self.services.httpClient fetchCalculateMonthRepayWithAppLmt:appLmt AndLoanTerm:loanTerm AndProductCode:self.loanType.typeID AndJionLifeInsurance:jionLifeInsurance] catch:^RACSignal *(NSError *error) {
				MSFResponse *response = [[MSFResponse alloc] initWithHTTPURLResponse:nil parsedResult:@{@"repayMoneyMonth": @0}];
				return [RACSignal return:response];
			}] map:^id(MSFCalculatemMonthRepayModel *model) {
				if (![model isKindOfClass:MSFCalculatemMonthRepayModel.class]) {
					[[NSNotificationCenter defaultCenter] postNotificationName:@"RepayMoneyMonthNotifacation" object:nil];
					self.loanFixedAmt = @"0.00";
					self.lifeInsuranceAmt = @"0.00";
					
					[SVProgressHUD dismiss];
					return nil;
				}
				[[NSNotificationCenter defaultCenter] postNotificationName:@"RepayMoneyMonthNotifacation" object:nil];
				[SVProgressHUD dismiss];
				[self performSelector:@selector(setSVPBackGround) withObject:self afterDelay:1];

				self.loanFixedAmt = model.loanFixedAmt;
				self.lifeInsuranceAmt = model.lifeInsuranceAmt;
				return model;
			}];
		}];
	
	_executeLifeInsuranceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executeLifeInsuranceSignal];
	}];
	
	_executePurposeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal];
	}];
	
	_executeNextCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executeNextSignal];
	}];
}

- (RACSignal *)executePurposeSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel selectViewModelWithFilename:@"moneyUse"];
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(id x) {
			self.purpose = x;
			[self.services popViewModel];
		}];
		[subscriber sendCompleted];
		return nil;
	}];
	return nil;
}

- (RACSignal *)executeLifeInsuranceSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFLifeInsuranceViewModel *viewModel = [[MSFLifeInsuranceViewModel alloc] initWithServices:self.services loanType:self.loanType];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)executeNextSignal {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		if (!self.product || self.appLmt.intValue == 0) {
			if (self.appLmt.intValue == 0) {
				[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请选择贷款钱数", }]];
				return nil;
			}
			[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请选择贷款期数"}]];
			return nil;
		}
		if (!self.purpose) {
			[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"请选择贷款用途"}]];
			return nil;
		}
		if ([self.loanFixedAmt isEqualToString:@"0.00"] || [self.loanFixedAmt isEqualToString:@"0"] || self.loanFixedAmt == nil) {
			[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"每月还款金额获取失败"}]];
			return nil;
		}
		MSFLoanAgreementViewModel *viewModel = [[MSFLoanAgreementViewModel alloc] initWithApplicationViewModel:self];
		[self.services pushViewModel:viewModel];
		
		[subscriber sendCompleted];
		return nil;
	}];
}

- (void)setSVPBackGround {
	[SVProgressHUD setBackgroundColor:[UIColor colorWithHue:0 saturation:0 brightness:0.95 alpha:0.8]];
	[SVProgressHUD setForegroundColor:[UIColor blackColor]];
	[SVProgressHUD resetOffsetFromCenter];
	
}

- (RACSignal *)submitSignalWithStatus:(NSString *)status {
	return [self.services.httpClient fetchSubmitWithApplyVO:self.model AndAcessory:self.array Andstatus:status];
}

@end