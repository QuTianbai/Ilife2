//
// MSFBasicViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFPersonalViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFFormsViewModel.h"
#import "MSFApplyInfo.h"

@interface MSFPersonalViewModel ()

@property(nonatomic,readonly) MSFFormsViewModel *viewModel;

@end

@implementation MSFPersonalViewModel

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)viewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
	_model = viewModel.model;
	
  return self;
}

@end
