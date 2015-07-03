//
// MSFAFStudentViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAFStudentViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFSelectKeyValues.h"
#import "MSFApplyInfo.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "MSFClient+MSFApplyCash.h"

@implementation MSFAFStudentViewModel

#pragma mark - Lifecycle

- (instancetype)initWithModel:(MSFApplyInfo *)model {
  if (!(self = [super initWithModel:model])) {
    return nil;
  }
  self.year = [NSDateFormatter msf_dateFromString:model.enrollmentYear];
  [self initialize];
  
  RACChannelTo(self,school) = RACChannelTo(self.model,universityName);
  RAC(self,model.enrollmentYear) = [[RACObserve(self, year) ignore:nil] map:^id(id value) {
    return [NSDateFormatter msf_stringFromDate:value];
  }];
  RAC(self.model,programLength) = [[RACObserve(self, length) ignore:nil] map:^id(MSFSelectKeyValues *value) {
    return value.code;
  }];
  
  @weakify(self)
  _executeRequest = [[RACCommand alloc] initWithEnabled:self.requestValidSignal signalBlock:^RACSignal *(id input) {
    @strongify(self)
    return self.executeRequestSignal;
  }];
  
  return self;
}

#pragma mark - Private

- (void)initialize {
  NSArray *degress = [MSFSelectKeyValues getSelectKeys:@"school_system"];
  [degress enumerateObjectsUsingBlock:^(MSFSelectKeyValues *obj, NSUInteger idx, BOOL *stop) {
    if ([obj.code isEqualToString:self.model.programLength]) {
      self.length = obj;
      *stop = YES;
    }
  }];
}

- (RACSignal *)requestValidSignal {
  return [RACSignal combineLatest:@[
    RACObserve(self, school),
    RACObserve(self, year),
    RACObserve(self, length)
    ]
   reduce:^id(NSString *school,NSDate *year, MSFSelectKeyValues *length){
    return @(school.length > 0 && year != nil && length != nil);
  }];
}

- (RACSignal *)executeRequestSignal {
  self.model.page = @"3";
  return [self.client applyInfoSubmit1:self.model];
}

@end
