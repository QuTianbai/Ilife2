//
// MSFProfessionalViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFProfessionalViewModel.h"
#import <FMDB/FMDB.h>
#import <MTLFMDBAdapter/MTLFMDBAdapter.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFSelectKeyValues.h"
#import "MSFApplicationForms.h"
#import "MSFAreas.h"
#import "MSFClient+MSFApplyCash.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "NSString+Matches.h"

@implementation MSFProfessionalViewModel

#pragma mark - Lifecycle

/*

//TODO: refact to super class
- (instancetype)initWithModel:(MSFApplyInfo *)model {
  if (!(self = [super initWithModel:model])) {
    return nil;
  }
  self.date = [NSDateFormatter msf_dateFromString:model.currentJobDate];
  
  [self initialize];
  RAC(self.model,education) = [[RACObserve(self, degrees) ignore:nil] map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
  RAC(self.model,socialStatus) = [[RACObserve(self, profession) ignore:nil] map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
  RAC(self.model,workingLength) = [[RACObserve(self, seniority) ignore:nil] map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
  RAC(self.model,industry) = [[RACObserve(self, industry) ignore:nil] map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
  RAC(self.model,title) = [[RACObserve(self, position) ignore:nil] map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
  RAC(self.model,companyType) = [[RACObserve(self, nature) ignore:nil] map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
  RAC(self.model,currentJobDate) = [[RACObserve(self, date) ignore:nil] map:^id(NSDate *value) {
    return [NSDateFormatter msf_stringFromDate:value];
  }];
  RACChannelTo(self,company) = RACChannelTo(self.model,company);
  RACChannelTo(self,address) = RACChannelTo(self.model,workTown);
  RACChannelTo(self,areaCode) = RACChannelTo(self.model,unitAreaCode);
  RACChannelTo(self,telephone) = RACChannelTo(self.model,unitTelephone);
  RACChannelTo(self,extensionTelephone) = RACChannelTo(self.model,unitExtensionTelephone);
  
  @weakify(self)
  [[RACObserve(self, province) ignore:nil] subscribeNext:^(MSFAreas *area) {
    @strongify(self)
    self.model.workProvinceCode = area.codeID;
    self.model.workProvince = area.name;
  }];
  [[RACObserve(self, city) ignore:nil] subscribeNext:^(MSFAreas *area) {
    @strongify(self)
    self.model.workCityCode = area.codeID;
    self.model.workCity = area.name;
  }];
  [[RACObserve(self, area) ignore:nil] subscribeNext:^(MSFAreas *area) {
    @strongify(self)
    self.model.workCountryCode = area.codeID;
    self.model.workCountry = area.name;
  }];
  
  _executeRequest = [[RACCommand alloc] initWithEnabled:self.requestValidSignal
    signalBlock:^RACSignal *(id input) {
      @strongify(self)
      return self.executeRequestSignal;
    }];
  
  _executeIncumbencyRequest = [[RACCommand alloc] initWithEnabled:self.executeIncumbencyValidRequest
    signalBlock:^RACSignal *(id input) {
      @strongify(self)
      return self.executeIncumbencyRequestSignal;
    }];
  
  return self;
}

#pragma mark - Private

- (void)initialize {
  NSArray *degress = [MSFSelectKeyValues getSelectKeys:@"edu_background"];
  [degress enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
    if ([obj.code isEqualToString:self.model.education]) {
      self.degrees = obj;
      *stop = YES;
    }
  }];
  NSArray *professions = [MSFSelectKeyValues getSelectKeys:@"social_status"];
  [professions enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
    if ([obj.code isEqualToString:self.model.socialStatus]) {
      self.profession = obj;
      *stop = YES;
    }
  }];
  NSArray *seniorities = [MSFSelectKeyValues getSelectKeys:@"service_year"];
  [seniorities enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
    if ([obj.code isEqualToString:self.model.workingLength]) {
      self.seniority = obj;
      *stop = YES;
    }
  }];
  NSArray *industries = [MSFSelectKeyValues getSelectKeys:@"industry_category"];
  [industries enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
    if ([obj.code isEqualToString:self.model.industry]) {
      self.industry = obj;
      *stop = YES;
    }
  }];
  NSArray *positions = [MSFSelectKeyValues getSelectKeys:@"position"];
  [positions enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
    if ([obj.code isEqualToString:self.model.title]) {
      self.position = obj;
      *stop = YES;
    }
  }];
  NSArray *natures = [MSFSelectKeyValues getSelectKeys:@"unit_nature"];
  [natures enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
    if ([obj.code isEqualToString:self.model.companyType]) {
      self.nature = obj;
      *stop = YES;
    }
  }];
  
  FMResultSet *rs;
  FMDatabase *fmdb = [FMDatabase databaseWithPath:[[NSBundle mainBundle] pathForResource:@"dicareas" ofType:@"db"]];
  [fmdb open];
  rs = [fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where area_code='%@'",self.model.workProvinceCode]];
  if (rs.next) {
    self.province = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:rs error:nil];
  }
  rs = [fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where area_code='%@'",self.model.workCityCode]];
  if (rs.next) {
    self.city = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:rs error:nil];
  }
  rs = [fmdb executeQuery:[NSString stringWithFormat:@"select * from basic_dic_area where area_code='%@'",self.model.workCountryCode]];
  if (rs.next) {
    self.area = [MTLFMDBAdapter modelOfClass:MSFAreas.class fromFMResultSet:rs error:nil];
  }
  [fmdb close];
}

- (RACSignal *)executeRequestSignal {
  self.model.page = @"3";
  
  return [self.client applyInfoSubmit1:self.model];
}

- (RACSignal *)executeIncumbencyRequestSignal {
  self.model.page = @"3";
  
  return [self.client applyInfoSubmit1:self.model];
}

#pragma mark - Public

- (RACSignal *)requestValidSignal {
  return [RACSignal combineLatest:@[
    RACObserve(self, degrees),
    RACObserve(self, profession)
    ]
   reduce:^id(MSFSelectKeyValues *degress, MSFSelectKeyValues *profession){
     return @(degress != nil && profession != nil);
   }];
}

- (RACSignal *)executeIncumbencyValidRequest {
  return [RACSignal combineLatest:@[
    RACObserve(self, degrees),
    RACObserve(self, profession),
    RACObserve(self, seniority),
    RACObserve(self, company),
    RACObserve(self, industry),
    RACObserve(self, position),
    RACObserve(self, nature),
    RACObserve(self, date),
    RACObserve(self, areaCode),
    RACObserve(self, telephone),
    RACObserve(self, extensionTelephone),
    RACObserve(self, province),
    RACObserve(self, address),
    ]
   reduce:^id (
     MSFSelectKeyValues *degress,
     MSFSelectKeyValues *profession,
     MSFSelectKeyValues *seniority,
     NSString *company,
     MSFSelectKeyValues *industry,
     MSFSelectKeyValues *position,
     MSFSelectKeyValues *nature,
     NSDate *date,
     NSString *areaCode,
     NSString *telephone,
     NSString *extensionTelephone,
     MSFSelectKeyValues *province,
     NSString *address
     ) {
     NSString *tel = [NSString stringWithFormat:@"%@%@",areaCode,telephone];
     return @(
     position != nil &&
     seniority != nil &&
     degress != nil &&
     company.length > 0 &&
     industry != nil &&
     nature != nil &&
     date != nil &&
     areaCode != nil &&
     telephone != nil &&
     extensionTelephone != nil &&
     province != nil &&
     address.length > 0 &&
     tel.isTelephone
     );
   }];
}
*/

@end
