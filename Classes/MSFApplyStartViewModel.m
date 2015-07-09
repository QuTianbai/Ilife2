//
//  MSFApplyStartViewModel.m
//  Cash
//
//  Created by xbm on 15/5/28.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFApplyStartViewModel.h"
#import "MSFUtils.h"
#import "MSFMonths.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <FMDB/FMDB.h>
#import "MSFClient+MSFCheckEmploee.h"
#import "MSFCheckEmployee.h"
#import "MSFClient+MSFApplyInfo.h"
#import "MSFApplyInfo.h"
#import "MSFApplyCash.h"
#import "MSFClient+MSFApplyCash.h"
#import "MSFClient+Months.h"
#import "MSFResponse.h"
#import "MSFSelectKeyValues.h"
#import "MSFProductViewModel.h"
#import "MSFAFCareerViewModel.h"
#import "MSFAFStudentViewModel.h"
#import "MSFAreas.h"
#import "NSString+Matches.h"
#import "MSFSubmitViewModel.h"
#import "MSFRelationMemberViewModel.h"

@interface MSFApplyStartViewModel ()

@end

@implementation MSFApplyStartViewModel

/*

- (instancetype)initWithEmployee:(MSFCheckEmployee *)employee applyInfo:(MSFApplyInfo *)applyInfo {
  if (!(self = [super init])) {
    return nil;
  }
  _checkEmployee = employee;
  _applyInfoModel = applyInfo;
  [self initialize];
  
//  _requestViewModel = [[MSFAFRequestViewModel alloc] initWithModel:applyInfo productSet:employee];
  _careerViewModel = [[MSFAFCareerViewModel alloc] initWithModel:applyInfo];
  _studentViewModel = [[MSFAFStudentViewModel alloc] initWithModel:applyInfo];
  
  _submitViewModel = [[MSFSubmitViewModel alloc] initWithModel:applyInfo productSet:employee];
  _relationViewModel = [[MSFRelationMemberViewModel alloc] initWithModel:applyInfo];
  @weakify(self)
  _executeNextPage = [[RACCommand alloc] initWithEnabled:self.cashMoneyNum signalBlock:^RACSignal *(id input) {
    @strongify(self)
    
    return [self executeCashMoneySignal];
  }];
  _executeIncome = [[RACCommand alloc] initWithEnabled:self.cashMoneyNum signalBlock:^RACSignal *(id input) {
    @strongify(self)
    
    return [self executeCashMoneySignal];
  }];
  
  _executeBasic = [[RACCommand alloc] initWithEnabled:self.basicValidSignal signalBlock:^RACSignal *(id input) {
    @strongify(self)
    
    return [self executeBasicSignal];
  }];
  
  _executeInJob = [[RACCommand alloc] initWithEnabled:self.cashMoneyNum signalBlock:^RACSignal *(id input) {
    @strongify(self)
    
    return [self executeCashMoneySignal];
  }];
  
  _executeNextPage = [[RACCommand alloc] initWithEnabled:self.cashMoneyNum signalBlock:^RACSignal *(id input) {
    @strongify(self)
    
    return [self executeCashMoneySignal];
  }];
  
  _executeFamily = [[RACCommand alloc] initWithEnabled:self.cashMoneyNum signalBlock:^RACSignal *(id input) {
    @strongify(self)
    
    return [self executeCashMoneySignal];
  }];
  
  _executeSubmit = [[RACCommand alloc] initWithEnabled:self.cashMoneyNum signalBlock:^RACSignal *(id input) {
    @strongify(self)
    
    return [self executeCashMoneySignal];
  }];
  
  _executeStudent = [[RACCommand alloc] initWithEnabled:self.cashMoneyNum signalBlock:^RACSignal *(id input) {
    @strongify(self)
    
    return [self executeCashMoneySignal];
  }];
  
  _executeFree =  [[RACCommand alloc] initWithEnabled:self.cashMoneyNum signalBlock:^RACSignal *(id input) {
    @strongify(self)
    
    return [self executeCashMoneySignal];
  }];
  
  [[RACObserve(self, province) ignore:nil] subscribeNext:^(MSFAreas *area) {
    @strongify(self)
    self.applyInfoModel.currentProvinceCode = area.codeID;
    self.applyInfoModel.currentProvince = area.name;
  }];
  [[RACObserve(self, city) ignore:nil] subscribeNext:^(MSFAreas *area) {
    @strongify(self)
    self.applyInfoModel.currentCityCode = area.codeID;
    self.applyInfoModel.currentCity = area.name;
  }];
  [[RACObserve(self, area) ignore:nil] subscribeNext:^(MSFAreas *area) {
    @strongify(self)
    self.applyInfoModel.currentCountryCode = area.codeID;
    self.applyInfoModel.currentCountry = area.name;
  }];

  return self;
}

#pragma mark - Private

- (RACSignal *)cashMoneyNum {
  //TODO: 家庭信息合法性判断
  return [RACSignal return:@YES];
  return [RACSignal combineLatest:@[
     RACObserve(self.applyInfoModel, principal),
     RACObserve(self.applyInfoModel, usageCode),
     RACObserve(self.applyInfoModel, tenor)]
   reduce:^id(NSString *cashMoney,NSString *used,NSString *tenor){
     return @(cashMoney.intValue>=_checkEmployee.allMinAmount.intValue && cashMoney.intValue<=_checkEmployee.allMaxAmount.intValue && used && ![used isEqualToString:@""] && tenor && ![tenor isEqualToString:@""]);
   }];
}

- (RACSignal *)executeCashMoneySignal {
  return [self.client applyInfoSubmit1:self.applyInfoModel];
}

- (RACSignal *)executeBasicSignal {
  self.applyInfoModel.page = @"2";
  
  return [self.client applyInfoSubmit1:self.applyInfoModel];
}

- (void)initialize {
  FMResultSet *rs;
  FMDatabase *fmdb = [FMDatabase databaseWithPath:[[NSBundle mainBundle] pathForResource:@"dicareas" ofType:@"db"]];
  [fmdb open];
  rs = [fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where area_code='%@'",self.applyInfoModel.currentProvinceCode]];
  if (rs.next) {
    self.province = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:rs error:nil];
  }
  rs = [fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where area_code='%@'",self.applyInfoModel.currentCityCode]];
  if (rs.next) {
    self.city = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:rs error:nil];
  }
  rs = [fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where area_code='%@'",self.applyInfoModel.currentCountryCode]];
  if (rs.next) {
    self.area = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:rs error:nil];
  }
  [fmdb close];
}

#pragma mark - Custom Accessors

- (MSFClient *)client {
  return MSFUtils.httpClient;
}

- (RACSignal *)basicValidSignal {
  return [RACSignal combineLatest:@[
    RACObserve(self.applyInfoModel, income),
    RACObserve(self.applyInfoModel, familyExpense),
    RACObserve(self.applyInfoModel, otherIncome),
    RACObserve(self.applyInfoModel, homeCode),
    RACObserve(self.applyInfoModel, homeLine),
    RACObserve(self.applyInfoModel, email),
    RACObserve(self.applyInfoModel, currentProvince),
    RACObserve(self.applyInfoModel, currentTown),
    RACObserve(self.applyInfoModel, currentStreet),
    RACObserve(self.applyInfoModel, currentCommunity),
    RACObserve(self.applyInfoModel, currentApartment)
    ]
   reduce:^ id(
      NSString *income,
      NSString *month,
      NSString *moreincome,
      NSString *homecode,
      NSString *telephone,
      NSString *email,
      NSString *province,
      NSString *town,
      NSString *street,
      NSString *community,
      NSString *aprtment
               ){
     NSString *tel = [NSString stringWithFormat:@"%@%@",homecode,telephone];
     return @(
     income.isScalar &&
     month.isScalar &&
     moreincome.isScalar &&
     homecode.isScalar &&
     tel.isTelephone &&
     email.isMail &&
     province != nil &&
     [self isAddreaa:town street:street community:community apartment:aprtment]
     );
   }];
}

- (BOOL)isAddreaa:(NSString *)town street:(NSString *)street community:(NSString *)community apartment:(NSString *)apartment {
  NSArray *array = [NSArray arrayWithObjects:town,street,community,apartment, nil];
  int count = 0;
  for (NSString *str in array) {
    if ([self isvalid:str]) {
      count++;
    }
  }
  if (count>=2) {
    return YES;
  }
  return NO;
}

- (BOOL)isvalid:(NSString *)str {
  return (str.length>0 && str.length<=10);
}
*/

@end
