//
// MSFProductViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFProductViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFMarket.h"
#import "MSFApplicationForms.h"
#import "MSFSelectKeyValues.h"
#import "MSFClient+MSFApplyCash.h"
#import "MSFProduct.h"
#import "MSFClient+Months.h"
#import "MSFResponse.h"
#import "MSFWebViewController.h"
#import "MSFUtils.h"
#import "MSFAgreementViewModel.h"
#import "MSFAgreement.h"
#import "MSFFormsViewModel.h"
#import "MSFSelectionViewModel.h"
#import "MSFSelectionViewController.h"
#import "MSFLoanAgreementViewModel.h"
#import "MSFWebViewModel.h"
#import "MSFTeams.h"
#import "SVProgressHUD.h"

@interface MSFProductViewModel ()

@property (nonatomic, weak) id <MSFViewModelServices> services;

@end

@implementation MSFProductViewModel

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFProductViewModel `-dealloc`");
}

- (instancetype)initWithFormsViewModel:(id)viewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_formsViewModel = viewModel;
	_totalAmount = @"";
	_productTerms = @"";
	_termAmount = 0;
	_services = self.formsViewModel.services;
	RAC(self, formsViewModel.model.repayMoneyMonth) = [RACObserve(self, termAmount) map:^id(NSNumber *value) {
		return [NSString stringWithFormat:@"%.2lf", value.doubleValue];
	}];
	RAC(self, formsViewModel.model.principal) = RACObserve(self, totalAmount);
	RAC(self, formsViewModel.model.isSafePlan) = [RACObserve(self, insurance) map:^id(id value) {
		return [value stringValue];
	}];
  
	RAC(self, formsViewModel.model.usageCode) = [RACObserve(self, purpose) map:^id(MSFSelectKeyValues *value) {
		return value.code;
	}];
	
	RAC(self, market) = RACObserve(self.formsViewModel, market);
	
	@weakify(self)
	[RACObserve(self, product) subscribeNext:^(MSFProduct *product) {
		@strongify(self)
		self.formsViewModel.model.productId = product.productId;
		self.formsViewModel.model.productName = product.productName;
		self.formsViewModel.model.productId = product.productId;
		self.formsViewModel.model.proGroupId = product.proGroupId;
		self.formsViewModel.model.proGroupName = product.proGroupName;
		self.formsViewModel.model.productGroupCode = product.productGroupCode;
		self.formsViewModel.model.tenor = product.period;
		self.formsViewModel.model.monthlyFeeRate = product.monthlyFeeRate;
		self.formsViewModel.model.monthlyInterestRate = product.monthlyInterestRate;
		
		self.productTerms = product.title;
	}];
	
	RAC(self, termAmount) = [[RACSignal
		combineLatest:@[
			RACObserve(self, product),
			RACObserve(self, insurance),
		]]
		flattenMap:^RACStream *(RACTuple *productAndInsurance) {
			@strongify(self)
			RACTupleUnpack(MSFProduct *product, NSNumber *insurance) = productAndInsurance;
			if (!product) {
				return [RACSignal return:@0];
			}
			return [[[self.services.httpClient
				fetchTermPayWithProduct:product totalAmount:self.totalAmount.integerValue insurance:insurance.boolValue]
				catch:^RACSignal *(NSError *error) {
					MSFResponse *response = [[MSFResponse alloc] initWithHTTPURLResponse:nil parsedResult:@{@"repayMoneyMonth": @0}];
					return [RACSignal return:response];
				}]
				map:^id(MSFResponse *value) {
          [[NSNotificationCenter defaultCenter] postNotificationName:@"RepayMoneyMonthNotifacation" object:nil];
          [SVProgressHUD dismiss];
          [self performSelector:@selector(setSVPBackGround) withObject:self afterDelay:1];

          self.moneyInsurance = value.parsedResult[@"fee"];
					return value.parsedResult[@"repayMoneyMonth"];
				}];
		}];
  RAC(self, minMoney) = RACObserve(self.formsViewModel.market, allMinAmount);
                         
  RAC(self, maxMoney) = RACObserve(self.formsViewModel.market, allMaxAmount);
	RAC(self, totalAmountPlacholder) = [RACSignal combineLatest:@[
		RACObserve(self.formsViewModel.market, allMinAmount),
		RACObserve(self.formsViewModel.market, allMaxAmount),
	] reduce:^id(NSString *min, NSString *max) {
		return min.integerValue != 0 ? [NSString stringWithFormat:@"请输入%@-%@之间的数字", min,max] : @"请输入贷款金额";
	}];
	
	RAC(self, termAmountText) = [RACObserve(self, termAmount) map:^id(NSNumber *value) {
		return value.integerValue != 0 ? [NSString stringWithFormat:@"%.2f", value.doubleValue] : @"-.--";
	}];
	RAC(self, purposeText) = [RACObserve(self, purpose) map:^id(id value) {
		return [value text];
	}];
	RAC(self, productTitle) = [RACObserve(self, product) map:^id(id value) {
		return [value title];
	}];
	_executeLifeInsuranceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executeLifeInsuranceSignal];
	}];
	_executePurposeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executePurposeSignal];
	}];
	_executeTermCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executeTermSignal];
	}];
	_executeNextCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		return [self executeNextSignal];
	}];
	
	return self;
}

#pragma mark - Private

- (RACSignal *)executeLifeInsuranceSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFWebViewModel *viewModel = [[MSFWebViewModel alloc] initWithURL:[MSFUtils.agreementViewModel.agreement lifeInsuranceURL]];
		[self.services pushViewModel:viewModel];
		[subscriber sendCompleted];
		return nil;
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

- (RACSignal *)executeTermSignal {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		if (self.market.teams.count == 0) {
			[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"系统繁忙，请稍后再试"
			}]];
			return nil;
		}
		MSFSelectionViewModel *viewModel = [MSFSelectionViewModel monthsViewModelWithProducts:self.market total:self.totalAmount.integerValue];
		if ([viewModel numberOfItemsInSection:0] == 0) {
			NSString *string;
			NSMutableArray *region = [[NSMutableArray alloc] init];
			[self.market.teams enumerateObjectsUsingBlock:^(MSFTeams *obj, NSUInteger idx, BOOL *stop) {
				[region addObject:[NSString stringWithFormat:@"%@ 到 %@ 之间", obj.minAmount,obj.maxAmount]];
			}];
			string = [NSString stringWithFormat:@"请输入贷款金额范围在 %@ 到 %@ 之间的数字", self.market.allMinAmount,self.market.allMaxAmount];
			
			[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: string,
			}]];
			return nil;
		}
		[self.services pushViewModel:viewModel];
		[viewModel.selectedSignal subscribeNext:^(id x) {
			self.product = x;
			[self.services popViewModel];
		}];
		
		return nil;
	}];
}

- (RACSignal *)executeNextSignal {
	@weakify(self)
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		@strongify(self)
		if (!self.product || self.termAmount == 0) {
			[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择贷款期数",
			}]];
			return nil;
		}
		if (!self.purpose) {
			[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{
				NSLocalizedFailureReasonErrorKey: @"请选择贷款用途",
			}]];
			return nil;
		}
		if (self.formsViewModel.pending) {
			[subscriber sendError:[NSError errorWithDomain:@"MSFProductViewController" code:0 userInfo:@{NSLocalizedFailureReasonErrorKey: @"您的提交的申请已经在审核中，请耐心等待!",
			}]];
			return nil;
		}
		MSFLoanAgreementViewModel *viewModel = [[MSFLoanAgreementViewModel alloc] initWithFromsViewModel:self.formsViewModel product:self.product];
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
