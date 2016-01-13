//
//  MSFCartViewModel.m
//  Finance
//
//  Created by 赵勇 on 12/23/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCartViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFClient+MSFCheckEmploee2.h"
#import "MSFClient+MSFCart.h"
#import "MSFClient+MSFCheckAllowApply.h"
#import "MSFCart.h"
#import "MSFTrial.h"
#import "MSFMarkets.h"
#import "MSFTeams2.h"
#import "MSFTeam.h"
#import "MSFLoanType.h"
#import "MSFLifeInsuranceViewModel.h"
#import "MSFLoanAgreementViewModel.h"
#import "MSFCheckAllowApply.h"
#import "MSFFormsViewModel.h"
#import "MSFMarkets.h"

@interface MSFCartViewModel ()

@property (nonatomic, strong, readwrite) MSFTrial *trial;
@property (nonatomic, strong, readwrite) MSFCart *cart;
@property (nonatomic, strong, readwrite) NSArray *terms;
@property (nonatomic, strong, readwrite) NSString *term;
@property (nonatomic, strong, readwrite) MSFMarkets *markets;
@property (nonatomic, strong, readwrite) NSString *compId; // 商铺编号
@property (nonatomic, assign, readwrite) BOOL barcodeInvalid;
@property (nonatomic, strong) NSString *maxLoan;
@property (nonatomic, strong) NSString *minLoan;

@end

@implementation MSFCartViewModel

- (instancetype)initWithApplicationNo:(NSString *)appNo services:(id<MSFViewModelServices>)services {
	self = [super init];
	if (self) {
		
		_services = services;
		_loanType = [[MSFLoanType alloc] initWithTypeID:@"3101"];
		_applicationNo = appNo;
		_formViewModel = [[MSFFormsViewModel alloc] initWithServices:self.services];
		_formViewModel.active = YES;
		
		_trial = [[MSFTrial alloc] init];
		_cart = [[MSFCart alloc] init];
		_lifeInsuranceAmt = @"";
		_loanFixedAmt = @"";
		_downPmtScale = @"";
		_totalAmt = @"";
		_term = @"";
		
		RAC(self, maxLoan) = RACObserve(self, formViewModel.markets.allMaxAmount);
		RAC(self, minLoan) = RACObserve(self, formViewModel.markets.allMinAmount);
		
		[RACObserve(self, trial) subscribeNext:^(MSFTrial *x) {
			self.loanFixedAmt = x.loanFixedAmt;
			self.lifeInsuranceAmt = x.lifeInsuranceAmt;
		}];
	
		RACChannelTerminal *downPmt = RACChannelTo(self, downPmtAmt);
		RACChannelTerminal *loanAmt = RACChannelTo(self, loanAmt);
		[[downPmt map:^id(NSString *value) {
			double loan = self.cart.totalAmt.doubleValue - value.doubleValue;
			return [NSString stringWithFormat:@"%.2f", loan];
		}] subscribe:loanAmt];
		
		_downPmtAmt = @"0";
		_joinInsurance = YES;
		
		@weakify(self)
		_executeInsuranceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			@strongify(self)
			return [self insuranceSignal];
		}];
		_executeTrialCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
			return [[self.services.httpClient fetchTrialAmount:self] doError:^(NSError *error) {
				[SVProgressHUD dismiss];
			}];
		}];
		self.executeTrialCommand.allowsConcurrentExecution = YES;
		[self.executeTrialCommand.executionSignals.switchToLatest subscribeNext:^(MSFTrial *x) {
			self.trial = x;
			self.promId = x.promId;
		}];
		[[RACSignal combineLatest:@[RACObserve(self, term), RACObserve(self, loanAmt), RACObserve(self, joinInsurance)]] subscribeNext:^(id x) {
			@strongify(self)
			if (self.downPmtAmt.doubleValue > self.totalAmt.doubleValue) {
				return;
			}
			[self.executeTrialCommand execute:nil];
		}];
		[[self.services.httpClient fetchCart:appNo] subscribeNext:^(MSFCart *x) {
			@strongify(self)
			self.barcodeInvalid = NO;
			self.cart = x;
			self.compId = self.cart.compId;
			self.totalAmt = self.cart.totalAmt;
		} error:^(NSError *error) {
			self.barcodeInvalid = YES;
		}];
		[[self.services.httpClient fetchCheckEmploeeWithProductCode:@"3101"] subscribeNext:^(MSFMarkets *x) {
			@strongify(self)
			[self handleMarkets:x];
		} error:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:@"请输入相应的首付金额"];
		}];
		
		[RACObserve(self, loanAmt) subscribeNext:^(id x) {
			@strongify(self)
			self.terms = [[[self.markets.teams.rac_sequence
				filter:^BOOL(MSFTeams2 *terms) {
					return (terms.minAmount.integerValue <= self.loanAmt.integerValue) && (terms.maxAmount.integerValue >=	 self.loanAmt.integerValue);
				}]
				flattenMap:^RACStream *(MSFTeams2 *value) {
					return value.team.rac_sequence;
				 }].array sortedArrayUsingComparator:^NSComparisonResult(MSFTeam *obj1, MSFTeam *obj2) {
						 if (obj1.loanTeam.integerValue < obj2.loanTeam.integerValue) {
							 return NSOrderedAscending;
						 } else if (obj1.loanTeam.integerValue > obj2.loanTeam.integerValue) {
							 return NSOrderedDescending;
						 }
						 
						 return NSOrderedSame;
				 }];;
			if (self.terms.count > 0) {
				self.term = [self.terms[0] loanTeam];
			}
			self.downPmtScale = [@(self.loanAmt.floatValue / self.totalAmt.floatValue) stringValue];
		}];
		_executeNextCommand = [[RACCommand alloc] initWithEnabled:self.agreementValidSignal signalBlock:^RACSignal *(id input) {
			@strongify(self)
			[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
			return [self.executeAgreementSignal doError:^(NSError *error) {
				[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
			}];
		}];
		_executeCompleteCommand = [[RACCommand alloc] initWithEnabled:[RACSignal return:@YES] signalBlock:^RACSignal *(id input) {
			return self.executeCompleteSignal;
		}];
	}
	return self;
}

- (void)handleMarkets:(MSFMarkets *)markets {
	self.markets = markets;
	self.terms = [[[markets.teams.rac_sequence filter:^BOOL(MSFTeams2 *terms) {
		return (terms.minAmount.integerValue <= self.loanAmt.integerValue) && (terms.maxAmount.integerValue >=	 self.loanAmt.integerValue);
	}]
	flattenMap:^RACStream *(MSFTeams2 *value) {
			return value.team.rac_sequence;
	}].array sortedArrayUsingComparator:^NSComparisonResult(MSFTeam *obj1, MSFTeam *obj2) {
		if (obj1.loanTeam.integerValue < obj2.loanTeam.integerValue) {
			return NSOrderedAscending;
		} else if (obj1.loanTeam.integerValue > obj2.loanTeam.integerValue) {
			return NSOrderedDescending;
		}
	
		return NSOrderedSame;
	}];;
	if (self.terms.count > 0) {
		self.term = [self.terms[0] loanTeam];
	}
}

- (NSString *)reuseIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == self.cart.cmdtyList.count) {
		switch (indexPath.row) {
			case 0: return @"MSFCartInputCell";
			case 1: return @"MSFCartContentCell";
			case 2: return @"MSFCartLoanTermCell";
			case 3: return @"MSFCartSwitchCell";
			case 4: return @"MSFCartTrialCell";
		}
	} else {
		if (indexPath.row == 0) {
			return @"MSFCartCategoryCell";
		}
		return @"MSFCartContentCell";
	}
	return nil;
}

#pragma mark - Signals

- (RACSignal *)insuranceSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFLifeInsuranceViewModel *viewModel = [[MSFLifeInsuranceViewModel alloc] initWithServices:self.services loanType:self.loanType];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

#pragma mark - Private

- (RACSignal *)agreementValidSignal {
	return [self.executeTrialCommand.executing map:^id(id value) {
		return @(![value boolValue]);
	}];
}

- (RACSignal *)executeAgreementSignal {
	return [[self.services.httpClient fetchCheckAllowApply] map:^id(MSFCheckAllowApply *model) {
		if (model.processing == 1) {
			double a = self.downPmtAmt.doubleValue;
			double d = self.cart.minDownPmt.doubleValue * self.totalAmt.doubleValue;
			double e = self.cart.maxDownPmt.doubleValue * self.totalAmt.doubleValue;
			double b = self.loanAmt.doubleValue;
			double f = self.minLoan.doubleValue;
			double g = self.maxLoan.doubleValue;
			double c = self.totalAmt.doubleValue;
			
			if (a <= d) {
				[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请填写%0.2f元及以上金额", d]];
				return nil;
			}
			if (a >= e) {
				[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请填写%0.2f元及以下金额", e]];
				return nil;
			}
			if (b <= f) {
				[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请填写%0.2f元及以下金额", c - f]];
				return nil;
			}
			if (b >= g) {
				[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请填写%0.2f元及以上金额", c - g]];
				return nil;
			}
			if (c < f + d) {
				[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请填写%0.2f元及以下金额", f + d]];
				return nil;
			}
			if (c > e + g) {
				[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请填写%0.2f元及以上金额", e + g]];
				return nil;
			}
			
			[SVProgressHUD dismiss];
			MSFLoanAgreementViewModel *viewModel = [[MSFLoanAgreementViewModel alloc] initWithApplicationViewModel:self];
			[self.services pushViewModel:viewModel];
			return nil;
		} else {
			[SVProgressHUD dismiss];
			[[[UIAlertView alloc] initWithTitle:@"提示" message:@"您目前还有一笔贷款正在进行中，暂不能申请贷款。" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
			return nil;
		}
	}];
}

- (RACSignal *)executeCompleteSignal {
	return [self.services.httpClient submitTrialAmount:self];
}

@end
