//
//  MSFApplyCashVIewModel.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFApplyCashVIewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFApplyCashModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFUtils.h"
#import "MSFCalculatemMonthRepayModel.h"
#import "MSFClient+MSFCalculateMonthRepay.h"
#import "MSFResponse.h"
#import "MSFMarkets.h"
#import "MSFSelectionViewModel.h"
#import "MSFWebViewModel.h"
#import "MSFAgreement.h"
#import "MSFAgreementViewModel.h"
#import "MSFTeam.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MSFApplyCashVIewModel ()

@property (nonatomic, copy) MSFCalculatemMonthRepayModel *calculateModel;

@end

@implementation MSFApplyCashVIewModel

- (instancetype)initWithViewModel:(MSFFormsViewModel *)viewModel {
	self = [super init];
	
	if (!self) {
		return nil;
	}
	_formViewModel = viewModel;
	_model = [[MSFApplyCashModel alloc] init];
	_services = viewModel.services;
	_model.productCd = MSFUtils.productCode;
	_jionLifeInsurance = @"";
	_appNO = @"";

	
	RAC(self, model.appNO) = RACObserve(self, appNO);
	RAC(self, model.appLmt) = RACObserve(self, appLmt);
	RAC(self, model.applyStatus) = RACObserve(self, applyStatus);
	
	RAC(self, model.jionLifeInsurance) = RACObserve(self, jionLifeInsurance);
	RAC(self, model.lifeInsuranceAmt) = RACObserve(self, lifeInsuranceAmt);
	RAC(self, model.loanFixedAmt) = RACObserve(self, loanFixedAmt);
	
	RAC(self, minMoney) = RACObserve(self, formViewModel.markets.allMinAmount);
	RAC(self, maxMoney) = RACObserve(self, formViewModel.markets.allMaxAmount);
	
	RAC(self, model.loanPurpose) = [RACObserve(self, purpose) map:^id(MSFSelectKeyValues *value) {
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
					return [[[self.services.httpClient fetchCalculateMonthRepayWithAppLmt:appLmt AndLoanTerm:loanTerm AndProductCode:MSFUtils.productCode AndJionLifeInsurance:jionLifeInsurance] catch:^RACSignal *(NSError *error) {
						MSFResponse *response = [[MSFResponse alloc] initWithHTTPURLResponse:nil parsedResult:@{@"repayMoneyMonth": @0}];
						return [RACSignal return:response];
					}] map:^id(MSFCalculatemMonthRepayModel *model) {
						if (![model isKindOfClass:MSFCalculatemMonthRepayModel.class]) {
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
	
	
	return self;
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
		MSFWebViewModel *viewModel = [[MSFWebViewModel alloc] initWithURL:[MSFUtils.agreementViewModel.agreement lifeInsuranceURL]];
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

@end
