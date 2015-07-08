//
// MSFAFRequestViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAFRequestViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFCheckEmployee.h"
#import "MSFApplyInfo.h"
#import "MSFSelectKeyValues.h"
#import "MSFClient+MSFApplyCash.h"
#import "MSFMonths.h"
#import "MSFClient+Months.h"
#import "MSFResponse.h"
#import "MSFWebViewController.h"
#import "MSFUtils.h"
#import "MSFAgreementViewModel.h"
#import "MSFAgreement.h"

@interface MSFAFRequestViewModel ()

@property(nonatomic,strong) MSFAFViewModel *viewModel;

@end

@implementation MSFAFRequestViewModel

#pragma mark - Lifecycle

- (instancetype)initWithViewModel:(id)viewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
	RAC(self.viewModel.model,principal) = RACObserve(self, totalAmount);
	RAC(self.viewModel.model,isSafePlan) = [RACObserve(self, insurance) map:^id(id value) {
		return [value stringValue];
	}];
	RAC(self.viewModel.model,usageCode) = [RACObserve(self, purpose) map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
	
	// 单向属性，这里的数字不需要读取服务器缓存，采用客户端每次输入
	@weakify(self)
	[[RACObserve(self, product) ignore:nil] subscribeNext:^(MSFMonths *product) {
		//TODO: 考虑调整model的属性为只读属性，是否满足RAC多次使用，以及product为空的情况
		@strongify(self)
		self.viewModel.model.productId = product.productId;
		self.viewModel.model.productName = product.productName;
		self.viewModel.model.productId = product.productId;
		self.viewModel.model.proGroupId = product.proGroupId;
		self.viewModel.model.proGroupName = product.proGroupName;
		self.viewModel.model.productGroupCode = product.productGroupCode;
		self.viewModel.model.tenor = product.period;
		self.viewModel.model.monthlyFeeRate = product.monthlyFeeRate;
		self.viewModel.model.monthlyInterestRate = product.monthlyInterestRate;
		
		self.productTerms = product.title;
		RAC(self,termAmount) = [[self.viewModel.client
			fetchTermPayWithProduct:product totalAmount:self.totalAmount.integerValue insurance:self.insurance]
			map:^id(MSFResponse *value) {
				return value.parsedResult[@"repayMoneyMonth"];
			}];
	}];
	
	_executeRequest = [[RACCommand alloc] initWithEnabled:self.requestValidSignal
		signalBlock:^RACSignal *(id input) {
			@strongify(self)
			return [self.viewModel submitSignalWithPage:1];
		}];
	
  return self;
}

- (instancetype)initWithModel:(MSFApplyInfo *)model productSet:(MSFCheckEmployee *)productSet {
  if (!(self = [super initWithModel:model productSet:productSet])) {
    return nil;
  }
  _insurance = YES;
  @weakify(self)
  RACChannelTo(self.model,principal) = RACChannelTo(self, totalAmount);
  RAC(self.model,isSafePlan) = [RACObserve(self, insurance) map:^id(NSNumber *value) {
    return value.stringValue;
  }];
  RAC(self.model,repayMoneyMonth) = [RACObserve(self, termAmount) map:^id(id value) {
    return [value stringValue];
  }];
  RAC(self.model,usageCode) = [[RACObserve(self, purpose) ignore:nil] map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
  
  [[RACObserve(self, totalAmount) distinctUntilChanged] subscribeNext:^(id x) {
    @strongify(self)
    self.productTerms = @"";
    self.model.productId = @"";
    self.model.productName = @"";
    self.model.productId = @"";
    self.model.proGroupId = @"";
    self.model.proGroupName = @"";
    self.model.productGroupCode = @"";
    self.model.tenor = @"";
    self.termAmount = 0;
  }];
  
  [[RACObserve(self,product) ignore:nil] subscribeNext:^(MSFMonths *month) {
    @strongify(self)
    self.productTerms = month.title;
    
    self.model.productId = month.productId;
    self.model.productName = month.productName;
    self.model.productId = month.proGroupId;
    self.model.proGroupId = month.proGroupId;
    self.model.proGroupName = month.proGroupName;
    self.model.productGroupCode = month.productGroupCode;
    self.model.tenor = month.period;
    
    RAC(self,termAmount) = [[self.client
      fetchTermPayWithProduct:month totalAmount:self.totalAmount.integerValue insurance:self.insurance]
      map:^id(MSFResponse *value) {
        return value.parsedResult[@"repayMoneyMonth"];
      }];
  }];
  
  [[[RACObserve(self, insurance) distinctUntilChanged]
    filter:^BOOL(id value) {
      @strongify(self)
      return self.product != nil;
    }]
    subscribeNext:^(id x) {
      @strongify(self)
      RAC(self,termAmount) = [[self.client
      fetchTermPayWithProduct:self.product totalAmount:self.totalAmount.integerValue insurance:self.insurance]
      map:^id(MSFResponse *value) {
        return value.parsedResult[@"repayMoneyMonth"];
      }];
  }];
  
  _executeRequest = [[RACCommand alloc] initWithEnabled:self.requestValidSignal signalBlock:^RACSignal *(id input) {
    @strongify(self)
    return [self executeRequestSignal];
  }];
  
  _executeAgreeOnLicense = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
    @strongify(self)
    self.agreeOnLicense = !self.agreeOnLicense;
    return [RACSignal return:@(self.agreeOnLicense)];
  }];
	
  return self;
}

#pragma mark - Private

- (RACSignal *)executeRequestSignal {
  self.model.page = @"1";
  return [self.client applyInfoSubmit1:self.model];
}

- (RACSignal *)requestValidSignal {
  @weakify(self)
	if (self.viewModel) {
		return [RACSignal combineLatest:@[
			RACObserve(self.viewModel.model, principal),
			RACObserve(self.viewModel.model, tenor),
			RACObserve(self.viewModel.model, usageCode),
			]
		 reduce:^id(NSString *amount,NSString *tenor,NSString *usage) {
			 @strongify(self)
			 NSInteger total = amount.integerValue;
			 
			 return @(
			 total > 100 &&
			 total % 100 == 0 &&
			 total >= self.productSet.allMinAmount.integerValue &&
			 total <= self.productSet.allMaxAmount.integerValue &&
			 tenor != nil &&
			 usage != nil
			 );
		 }];
	}
  return [RACSignal combineLatest:@[
    RACObserve(self.model, principal),
    RACObserve(self.model, tenor),
    RACObserve(self.model, usageCode),
    ]
   reduce:^id(NSString *amount,NSString *tenor,NSString *usage) {
     @strongify(self)
     NSInteger total = amount.integerValue;
     
     return @(
     total > 100 &&
     total % 100 == 0 &&
     total >= self.productSet.allMinAmount.integerValue &&
     total <= self.productSet.allMaxAmount.integerValue &&
     tenor != nil &&
     usage != nil
     );
   }];
}

@end
