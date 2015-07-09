//
//  MSFRelationMemberViewModel.m
//  Cash
//
//  Created by xutian on 15/6/13.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFRelationMemberViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFApplyInfo.h"
#import "MSFClient+MSFApplyCash.h"

@implementation MSFRelationMemberViewModel

/*
- (instancetype)initWithModel:(MSFApplyInfo *)model {
  if (!(self = [super init])) {
    
    return nil;
  }
  [self initialize];
  RAC(self.model,maritalStatus) = [[RACObserve(self, marryValues) ignore:nil]
                                   map:^id(MSFSelectKeyValues *value) {
                                     return value.code;
                                   }];
  RAC(self.model,houseType) = [[RACObserve(self, houseValues) ignore:nil]
                               map:^id(MSFSelectKeyValues *value) {
                                 return value.code;
                               }];
  RAC(self.model,memberRelation) = [[RACObserve(self, familyOneValues) ignore:nil]
                                    map:^id(MSFSelectKeyValues *value) {
                                      return value.code;
                                    }];
  RAC(self.model,memberRelation2) = [[RACObserve(self, familyTwoValues) ignore:nil]
                                     map:^id(MSFSelectKeyValues *value) {
                                       return value.code;
                                     }];
  RAC(self.model,relation1) = [[RACObserve(self, otherOneValues) ignore:nil]
                               map:^id(MSFSelectKeyValues *value) {
                                 return value.code;
                               }];
  RAC(self.model,relation2) = [[RACObserve(self, otherTwoValues) ignore:nil]
                               map:^id(MSFSelectKeyValues *value) {
                                 return value.code;
                               }];
  RACChannelTo(self,familyOneNameValues) = RACChannelTo(self.model, memberName);
  RACChannelTo(self,phoneNumOneValues) = RACChannelTo(self.model, memberCellNum);
  RACChannelTo(self,addressOneValues) = RACChannelTo(self.model, memberAddress);
  RACChannelTo(self,familyTwoNameValues) = RACChannelTo(self.model, memberName2);
  RACChannelTo(self,phoneNumTwoValues) = RACChannelTo(self.model, memberCellNum2);
  RACChannelTo(self,addressTwoValues) = RACChannelTo(self.model, memberAddress2);
  RACChannelTo(self,otherOneNameValues) = RACChannelTo(self.model, name1);
  RACChannelTo(self,otherPhoneOneValues) = RACChannelTo(self.model, phone1);
  RACChannelTo(self,otherTwoNameValues) = RACChannelTo(self.model, name2);
  RACChannelTo(self,otherPhoneTwoValues) = RACChannelTo(self.model, phone2);
  
  @weakify(self)
  _executeRequest = [[RACCommand alloc] initWithEnabled:self.requestValidSignal signalBlock:^RACSignal *(id input) {
    @strongify(self)
    return [self executeRequestSignal];
  }];
  
  return self;
}

- (RACSignal *)executeRequestSignal {
  self.model.page = @"4";
  
  return [self.client applyInfoSubmit1:self.model];
}

- (RACSignal *)requestValidSignal {
  return [RACSignal combineLatest:@[
                                    RACObserve(self, marryValues)
                                    ]
                           reduce:^id( MSFSelectKeyValues *marrige){
                             return @(marrige != nil);
                           }];
}

- (void)initialize {
  NSArray *marrages = [MSFSelectKeyValues getSelectKeys:@"marital_status"];
  [marrages enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
    if ([obj.code isEqualToString:self.model.maritalStatus]) {
      self.marryValues = obj;
      *stop = YES;
    }
  }];
  NSArray *housevalues = [MSFSelectKeyValues getSelectKeys:@"housing_conditions"];
  [housevalues enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
    if ([obj.code isEqualToString:self.model.houseType]) {
      self.houseValues = obj;
      *stop = YES;
    }
  }];
  
  NSArray *familyOneValues = [MSFSelectKeyValues getSelectKeys:@"familyMember_type"];
  [familyOneValues enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
    if ([obj.code isEqualToString:self.model.memberRelation]) {
      self.familyOneValues = obj;
      *stop = YES;
    }
  }];
//  NSArray *familyTwoValues = [MSFSelectKeyValues getSelectKeys:@""];
  [familyOneValues enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
    if ([obj.code isEqualToString:self.model.memberRelation2]) {
      self.familyTwoValues = obj;
      *stop = YES;
    }
  }];
  NSArray *otherRelations = [MSFSelectKeyValues getSelectKeys:@"relationship"];
  [otherRelations enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
    if ([obj.code isEqualToString:self.model.relation1]) {
      self.otherOneValues = obj;
      *stop = YES;
    }
  }];
  //NSArray *familyTwoValues = [MSFSelectKeyValues getSelectKeys:@""];
  [otherRelations enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
    if ([obj.code isEqualToString:self.model.relation2]) {
      self.otherTwoValues = obj;
      *stop = YES;
    }
  }];
  
}
*/

@end