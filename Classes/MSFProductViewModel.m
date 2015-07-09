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

@implementation MSFProductViewModel

#pragma mark - Lifecycle

- (instancetype)initWithFormsViewModel:(id)viewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_formsViewModel = viewModel;
	_totalAmount = @"";
	_productTerms = @"";
	_termAmount = 0;
	
	RAC(self.formsViewModel.model,principal) = RACObserve(self, totalAmount);
	RAC(self.formsViewModel.model,isSafePlan) = [RACObserve(self, insurance) map:^id(id value) {
		return [value stringValue];
	}];
	RAC(self.formsViewModel.model,usageCode) = [RACObserve(self, purpose) map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
	
	RAC(self,market) = RACObserve(self.formsViewModel, market);
	
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
	
	RAC(self,termAmount) = [[RACSignal
		combineLatest:@[
			RACObserve(self, product),
			RACObserve(self, insurance),
		]]
		flattenMap:^RACStream *(RACTuple *productAndInsurance) {
			RACTupleUnpack(MSFProduct *product, NSNumber *insurance) = productAndInsurance;
			if (!product) {
				return [RACSignal return:@0];
			}
			return	[[self.formsViewModel.client
				fetchTermPayWithProduct:product totalAmount:self.totalAmount.integerValue insurance:insurance.boolValue]
				map:^id(MSFResponse *value) {
					return value.parsedResult[@"repayMoneyMonth"];
				}];
		}];
	RAC(self,totalAmountPlacholder) = [RACSignal combineLatest:@[
		RACObserve(self.formsViewModel.market,allMinAmount),
		RACObserve(self.formsViewModel.market,allMaxAmount),
	] reduce:^id(NSString *min, NSString *max) {
		return min.integerValue != 0 ? [NSString stringWithFormat:@"请输入%@-%@之间的数字", min,max] : @"请输入贷款金额";
	}];
	
	RAC(self,termAmountText) = [RACObserve(self, termAmount) map:^id(NSNumber *value) {
		return value.integerValue != 0 ? value.stringValue : @"未知";
	}];
	RAC(self,purposeText) = [RACObserve(self, purpose) map:^id(id value) {
		return [value text];
	}];
	RAC(self,productTitle) = [RACObserve(self, product) map:^id(id value) {
		return [value title];
	}];
	
  return self;
}

@end
