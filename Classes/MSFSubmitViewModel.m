//
//  MSFSubmitViewModel.m
//  Cash
//
//  Created by xbm on 15/6/9.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSubmitViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFApplyInfo.h"
#import "MSFSelectKeyValues.h"
#import "MSFClient+MSFApplyCash.h"
#import "MSFPhotoStatus.h"
#import "MSFCheckEmployee.h"
#import "MSFPhotoStatus.h"

@implementation MSFSubmitViewModel

- (instancetype)initWithModel:(MSFApplyInfo *)model productSet:(MSFCheckEmployee *)productSet {
  if (!(self = [super initWithModel:model productSet:productSet])) {
    return nil;
  }
  
  RAC(self.model,bankName) = [[RACObserve(self, bankName) ignore:nil] map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
  //RAC(self.model,bankNumber) = RACObserve(self, bankCardNum);
  RACChannelTo(self,bankCardNum) = RACChannelTo(self.model,bankNumber);
  
  RACChannelTo(self,phtoStatus) = RACChannelTo(self.model,whitePhoto);
  
  @weakify(self)
  _executeRequest = [[RACCommand alloc] initWithEnabled:self.requestValidSignal signalBlock:^RACSignal *(id input) {
    @strongify(self)
    return [self executeRequestSignal];
  }];
  
  return self;
}

- (RACSignal *)executeRequestSignal {
  self.model.page = @"5";
  self.model.whitePhoto = nil;
//  return [self.client applyInfoSubmit1:self.model zipWith:self]
  return [self.client applyInfoSubmit1:self.model ];
}

- (RACSignal *)requestValidSignal {
  @weakify(self)
  return [RACSignal combineLatest:@[
    RACObserve(self, bankName),
    RACObserve(self,bankCardNum),
    RACObserve(self, phtoStatus)]
    reduce:^id(MSFSelectKeyValues *bankName,NSString *bankCardNum, MSFPhotoStatus *phtoStatus){
      @strongify(self)
      if (self.productSet.white) {
        return @(bankName != nil && bankCardNum.length > 0 && self.phtoStatus !=nil && self.phtoStatus.id_photo !=nil &&self.phtoStatus.owner_photo !=nil);
      }
      else {
        return @(bankName != nil && bankCardNum.length > 0 );
 
      }
    }];
}

@end
