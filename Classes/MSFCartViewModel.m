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
#import "MSFPersonalViewModel.h"
#import "MSFResponse.h"
#import "MSFPlanViewModel.h"
#import "MSFApplication.h"

@interface MSFCartViewModel ()

@property (nonatomic, strong, readwrite) MSFCart *cart;
@property (nonatomic, strong, readwrite) NSArray *terms;
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
	_trial = [[MSFTrial alloc] init];
	_lifeInsuranceAmt = @"";
	_loanFixedAmt = @"";
	_downPmtScale = @"";
	_totalAmt = @"";
	_term = @"";
	_downPmtAmt = @"";
	_applicationNo = self.cart.cartId;
	self.compId = self.cart.compId;
	self.totalAmt = self.cart.totalAmt;
	
	RAC(self, maxLoan) = RACObserve(self, markets.allMaxAmount);
	RAC(self, minLoan) = RACObserve(self, markets.allMinAmount);
	RAC(self, isDownPmt) = RACObserve(self, cart.isDownPmt);
	RAC(self, loanTerm) = RACObserve(self, term);
	RAC(self, amount) = RACObserve(self, loanAmt);
	
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
        @strongify(self);
        NSString *lifeInsuranceAmt = [NSString stringWithFormat:@"%@", x.loanTerm];
        if ([lifeInsuranceAmt isEqualToString:self.term]) {
            self.trial = x;
            self.promId = x.promId;
        }
	}];
	
	// 更新商品试算
	[RACObserve(self, trial) subscribeNext:^(MSFTrial *product) {
		@strongify(self)
		self.loanTerm = product.loanTerm;
		self.loanFixedAmt = product.loanFixedAmt;
		self.lifeInsuranceAmt = product.lifeInsuranceAmt;
	}];
	RAC(self, markets) = [[self.didBecomeActiveSignal
		 filter:^BOOL(id value) {
			 @strongify(self)
			 return !self.markets;
		 }]
		 flattenMap:^RACStream *(id value) {
			 return [self.services.httpClient fetchAmortizeWithProductCode:self.loanType.typeID];
		 }];
	
	RAC(self, viewModels) = [[RACSignal combineLatest:@[
		RACObserve(self, loanAmt),
		RACObserve(self, joinInsurance)
	]]
	flattenMap:^RACStream *(id value) {
		return [[self trialSignal].collect catch:^RACSignal *(NSError *error) {
			return [RACSignal empty];
		}];
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
	_executeNextCommand = [[RACCommand alloc] initWithEnabled:[self nextValidSignal] signalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self nextSignal];
	}];
	_executeCommitCommand = [[RACCommand alloc] initWithEnabled:[self commitValidSignal] signalBlock:^RACSignal *(id input) {
		return [self commitSignal];
	}];
	_executeProtocolCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [self executeAgreementSignal];
	}];
	
  return self;
}

#pragma mark - Custom Accessors

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

- (RACSignal *)nextValidSignal {
	return [self.executeTrialCommand.executing map:^id(id value) {
		return @(![value boolValue]);
	}];
}

- (RACSignal *)nextSignal {
	if (!self.hasAgreeProtocol) {
		[SVProgressHUD showInfoWithStatus:@"请同意申请协议"];
		return RACSignal.empty;
	}
	if (self.isDownPmt) {
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
			return RACSignal.empty;
		}
		if (a > e) {
			[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请填写%0.2f元及以下金额", e]];
			return RACSignal.empty;
		}
		if (b < f) {
			[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请填写%0.2f元及以下金额", c - f]];
			return RACSignal.empty;
		}
		if (b > g) {
			[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请填写%0.2f元及以上金额", c - g]];
			return RACSignal.empty;
		}
		if (c < f + d) {
			[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请填写%0.2f元及以下金额", f + d]];
			return RACSignal.empty;
		}
		if (c > e + g) {
			[SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"请填写%0.2f元及以上金额", e + g]];
			return RACSignal.empty;
		}
	}
	
	[SVProgressHUD showWithStatus:@"正在提交..."];
	@weakify(self)
	return [[[self.services.httpClient fetchCheckAllowApply]
		map:^id(MSFCheckAllowApply *model) {
			@strongify(self)
			if (model.processing == 1) {
				[SVProgressHUD dismiss];
				MSFPersonalViewModel *viewModel = [[MSFPersonalViewModel alloc] initWithViewModel:self services:self.services];
				[self.services pushViewModel:viewModel];
				return nil;
			} else {
				[SVProgressHUD dismiss];
				[[[UIAlertView alloc] initWithTitle:@"提示" message:@"您目前还有一笔贷款正在进行中，暂不能申请贷款。" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil] show];
				return nil;
			}
		}]
		doError:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
}

- (RACSignal *)executeAgreementSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFLoanAgreementViewModel *viewModel = [[MSFLoanAgreementViewModel alloc] initWithApplicationViewModel:self];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)trialSignal {
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
	parameters[@"appLmt"] = self.loanAmt;
	parameters[@"productCode"] = self.cart.crProdId;
	parameters[@"jionLifeInsurance"] = @(self.joinInsurance);
	parameters[@"compId"] = self.cart.compId;
	parameters[@"cmdtyList"] = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[MTLJSONAdapter JSONArrayFromModels:self.cart.cmdtyList] options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
	NSURLRequest *request = [self.services.httpClient requestWithMethod:@"POST" path:@"orders/trial" parameters:parameters];
	return [[[self.services.httpClient enqueueRequest:request resultClass:MSFTrial.class] msf_parsedResults] map:^id(id value) {
		return [[MSFPlanViewModel alloc] initWithModel:value];
	}];
}

- (RACSignal *)trialValidSignal {
	return [RACSignal combineLatest:@[
		RACObserve(self, terms),
	]
	reduce:^id(NSArray *terms){
		return @(terms.count > 0);
	}];
}

- (RACSignal *)commitSignal {
	NSDictionary *order = @{
		@"productCd": self.cart.crProdId?:@"",
		@"appLmt": self.loanAmt?:@"",
		@"loanTerm": self.term?:@"",
		@"jionLifeInsurance": [@(self.joinInsurance) stringValue],
		@"lifeInsuranceAmt": self.lifeInsuranceAmt?:@"",
		@"loanFixedAmt": self.loanFixedAmt?:@"",
		@"downPmtScale": self.downPmtScale?:@"",
		@"downPmtAmt": self.downPmtAmt?:@"",
		@"totalAmt": self.totalAmt?:@"",
		@"isDownPmt": [@(self.isDownPmt) stringValue],
		@"promId": self.trial.promId?:@"",
	};
	NSArray *accessories = self.accessories;
	NSDictionary *cart = [MTLJSONAdapter JSONDictionaryFromModel:self.cart];
	
	NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
	parameters[@"applyStatus"] = @"1";
	parameters[@"orderVO"] = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:order options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
	parameters[@"accessoryInfoVO"] = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:accessories options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
	parameters[@"cartVO"] = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:cart options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
	NSURLRequest *request = [self.services.httpClient requestWithMethod:@"POST" path:@"orders/createOrder" parameters:parameters];
	return [[self.services.httpClient enqueueRequest:request resultClass:nil] map:^id(MSFResponse *value) {
		return value.parsedResult[@"appNo"];
	}];
}

- (RACSignal *)commitValidSignal {
	return [RACSignal return:@YES];
}

@end
