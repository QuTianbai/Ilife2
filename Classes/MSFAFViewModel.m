//
// MSFAFViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAFViewModel.h"
#import "MSFUtils.h"

@implementation MSFAFViewModel

#pragma mark - Lifecycle

- (instancetype)initWithModel:(MSFApplyInfo *)model {
  if (!(self = [super init])) {
    return nil;
  }
  _model = model;
  
  return self;
}

- (instancetype)initWithModel:(MSFApplyInfo *)model productSet:(MSFCheckEmployee *)productSet {
  if (!(self = [super init])) {
    return nil;
  }
  _model = model;
  _productSet = productSet;
  
  return self;
}

#pragma mark - Custom Accessors

- (MSFClient *)client {
  return MSFUtils.httpClient;
}

@end
