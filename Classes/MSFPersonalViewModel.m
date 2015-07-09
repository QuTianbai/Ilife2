//
// MSFBasicViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFPersonalViewModel.h"
#import "MSFFormsViewModel.h"

@interface MSFPersonalViewModel ()

@property(nonatomic,readonly) MSFFormsViewModel *viewModel;

@end

@implementation MSFPersonalViewModel

- (instancetype)initWithViewModel:(id)viewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
  
  return self;
}

@end
