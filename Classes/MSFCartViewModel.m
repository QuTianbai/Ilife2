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
#import "MSFClient+Cart.h"
#import "MSFClient+CheckAllowApply.h"
#import "MSFCart.h"
#import "MSFTrial.h"
#import "MSFAmortize.h"
#import "MSFOrganize.h"
#import "MSFPlan.h"
#import "MSFLoanType.h"
#import "MSFLifeInsuranceViewModel.h"
#import "MSFLoanAgreementViewModel.h"
#import "MSFCheckAllowApply.h"
#import "MSFAmortize.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFClient+Amortize.h"

@interface MSFCartViewModel ()

@property (nonatomic, strong, readwrite) MSFTrial *trial;
@property (nonatomic, strong, readwrite) MSFCart *cart;
@property (nonatomic, strong, readwrite) NSArray *terms;
@property (nonatomic, strong, readwrite) NSString *term;
@property (nonatomic, strong, readwrite) MSFAmortize *markets;
@property (nonatomic, strong, readwrite) NSString *compId; // 商铺编号
@property (nonatomic, assign, readwrite) BOOL barcodeInvalid;
@property (nonatomic, strong) NSString *maxLoan;
@property (nonatomic, strong) NSString *minLoan;

@end

@implementation MSFCartViewModel

- (instancetype)initWithModel:(id)model services:(id <MSFViewModelServices>)services {
  self = [super init];
  if (!self) {
    return nil;
  }
	_cart = model;
	_services = services;
			
	_services = services;
	
	_trial = [[MSFTrial alloc] init];
	_lifeInsuranceAmt = @"";
	_loanFixedAmt = @"";
	_downPmtScale = @"";
	_totalAmt = @"";
	_term = @"";
	_downPmtAmt = @"";
	self.compId = self.cart.compId;
	self.totalAmt = self.cart.totalAmt;
	self.barcodeInvalid = NO;
	
	RAC(self, maxLoan) = RACObserve(self, markets.allMaxAmount);
	RAC(self, minLoan) = RACObserve(self, markets.allMinAmount);
	RAC(self, isDownPmt) = RACObserve(self, cart.isDownPmt);
	
	RAC(self, loanType) = [[RACObserve(self, cart.crProdId) ignore:nil] map:^id(id value) {
		return [[MSFLoanType alloc] initWithTypeID:value];
	}];
	
	[RACObserve(self, trial) subscribeNext:^(MSFTrial *x) {
		self.loanFixedAmt = x.loanFixedAmt;
		self.lifeInsuranceAmt = x.lifeInsuranceAmt;
	}];
	
	RAC(self, loanAmt) = [RACSignal combineLatest:@[
		RACObserve(self, downPmtAmt),
		RACObserve(self, totalAmt)
	]
	reduce:^id(NSString *pmt, NSString *amt) {
		double loan = amt.doubleValue - pmt.doubleValue;
		return [NSString stringWithFormat:@"%.2f", loan];
	}];
	
	_downPmtAmt = @"0";
	_joinInsurance = YES;
	
	@weakify(self)
	_executeInsuranceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self insuranceSignal];
	}];
	
	// 试算更新
	_executeTrialCommand = [[RACCommand alloc] initWithEnabled:self.trialValidSignal signalBlock:^RACSignal *(id input) {
		return self.trialSignal;
	}];
	[self.executeTrialCommand.executionSignals.switchToLatest subscribeNext:^(MSFTrial *x) {
		self.trial = x;
		self.promId = x.promId;
	}];
	
	// 更新商品试算
	[[RACSignal combineLatest:@[
		RACObserve(self, term),
		RACObserve(self, loanAmt),
		RACObserve(self, joinInsurance)
	]]
	subscribeNext:^(id x) {
		@strongify(self)
		NSLog(@"xxxx %@", [x description]);
		[self.executeTrialCommand execute:nil];
	}];
	
	// 根据贷款产品获取贷款资料
	[[RACObserve(self, loanType.typeID) ignore:nil] subscribeNext:^(id x) {
		[[self.services.httpClient fetchAmortizeWithProductCode:x] subscribeNext:^(MSFAmortize *x) {
			@strongify(self)
			[self handleMarkets:x];
		} error:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
	}];
	
	// 根据贷款金额更新贷款期数
	[RACObserve(self, loanAmt) subscribeNext:^(id x) {
		@strongify(self)
		self.terms = [[[self.markets.teams.rac_sequence
			filter:^BOOL(MSFOrganize *terms) {
				return (terms.minAmount.integerValue <= self.loanAmt.integerValue) && (terms.maxAmount.integerValue >=	 self.loanAmt.integerValue);
			}]
			flattenMap:^RACStream *(MSFOrganize *value) {
				return value.team.rac_sequence;
			 }].array sortedArrayUsingComparator:^NSComparisonResult(MSFPlan *obj1, MSFPlan *obj2) {
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
		self.downPmtScale = [@(self.downPmtAmt.floatValue / self.totalAmt.floatValue) stringValue];
	}];
	
	// 执行下一步操作
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
  
  return self;
}

- (instancetype)initWithApplicationNo:(NSString *)appNo services:(id<MSFViewModelServices>)services {
	self = [super init];
	if (!self) return nil;
	return self;
}

- (void)handleMarkets:(MSFAmortize *)markets {
	self.markets = markets;
	self.terms = [[[markets.teams.rac_sequence filter:^BOOL(MSFOrganize *terms) {
		return (terms.minAmount.integerValue <= self.loanAmt.integerValue) && (terms.maxAmount.integerValue >=	 self.loanAmt.integerValue);
	}]
	flattenMap:^RACStream *(MSFOrganize *value) {
			return value.team.rac_sequence;
	}].array sortedArrayUsingComparator:^NSComparisonResult(MSFPlan *obj1, MSFPlan *obj2) {
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
	
	double d = self.cart.minDownPmt.doubleValue * self.totalAmt.doubleValue;
	double a = self.minLoan.doubleValue;
	double c = self.cart.totalAmt.doubleValue;
	
	if (c < d + a) {
		[SVProgressHUD showErrorWithStatus:@"商品金额低于申请最低金额"];
	}
}

- (NSString *)reuseIdentifierForCellAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.cart.cartType isEqualToString:MSFCartCommodityIdentifier]) {
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
	} else if ([self.cart.cartType isEqualToString:MSFCartTravelIdentifier]) {
		if (indexPath.section == 2) { // 商品试算视图
			switch (indexPath.row) {
				case 0: return @"MSFCartInputCell";
				case 1: return @"MSFCartContentCell";
				case 2: return @"MSFCartLoanTermCell";
				case 3: return @"MSFCartSwitchCell";
				case 4: return @"MSFCartTrialCell";
			}
		} else {
			if (indexPath.row == 0 && indexPath.section == 0) {
				return @"MSFCartCategoryCell";
			}
			return @"MSFCartContentCell";
		}
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
			
			// Link to Message: Re: Re: BUG #1051 贷款最大金额计算有误 - 虚拟产品-测试专用 (From Jing Yang(杨静) <jing.yang@msxf.com>)
			if (a < d) {
				[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请填写%0.2f元及以上金额", d]];
				return nil;
			}
			if (a > e) {
				[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请填写%0.2f元及以下金额", e]];
				return nil;
			}
			if (b < f) {
				[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请填写%0.2f元及以下金额", c - f]];
				return nil;
			}
			if (b > g) {
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
//TODO: Fix
//	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
//	parameters[@"appLmt"] = self.loanAmt;
//	parameters[@"productCode"] = self.cart.crProdId;
//	parameters[@"jionLifeInsurance"] = @(self.joinInsurance);
//	parameters[@"compId"] = self.cart.compId;
//	parameters[@"cmdtyList"] = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONArrayFromModels:self.cart.cmdtyList] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
//	NSURLRequest *request = [self.services.httpClient requestWithMethod:@"POST" path:@"orders/trial" parameters:parameters];
//	return [[self.services.httpClient enqueueRequest:request resultClass:MSFTrial.class] msf_parsedResults];
	return [self.services.httpClient submitTrialAmount:self];
}

- (RACSignal *)trialSignal {
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
	parameters[@"appLmt"] = self.loanAmt;
	parameters[@"productCode"] = self.cart.crProdId;
	parameters[@"jionLifeInsurance"] = @(self.joinInsurance);
	parameters[@"compId"] = self.cart.compId;
	parameters[@"cmdtyList"] = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONArrayFromModels:self.cart.cmdtyList] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
	NSURLRequest *request = [self.services.httpClient requestWithMethod:@"POST" path:@"orders/trial" parameters:parameters];
	return [[self.services.httpClient enqueueRequest:request resultClass:MSFTrial.class] msf_parsedResults];
}

- (RACSignal *)trialValidSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self, terms),
	]
	reduce:^id(NSArray *terms){
		return @(terms.count > 0);
	}];
}

@end
