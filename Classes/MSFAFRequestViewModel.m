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

@implementation MSFAFRequestViewModel

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
      fetchTermPayWithProduct:month totalAmount:self.totalAmount insurance:self.insurance]
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
      fetchTermPayWithProduct:self.product totalAmount:self.totalAmount insurance:self.insurance]
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
  return [RACSignal combineLatest:@[
    RACObserve(self.model, principal),
    RACObserve(self.model, tenor),
    RACObserve(self.model, usageCode),
    RACObserve(self, agreeOnLicense),
    ]
   reduce:^id(NSString *amount,NSString *tenor,NSString *usage,NSNumber *agree){
     @strongify(self)
     NSInteger total = amount.integerValue;
     
     return @(
     total > 100 &&
     total % 100 == 0 &&
     total >= self.productSet.allMinAmount.integerValue &&
     total <= self.productSet.allMaxAmount.integerValue &&
     tenor != nil &&
     usage != nil &&
     agree.boolValue
     );
   }];
}

@end
