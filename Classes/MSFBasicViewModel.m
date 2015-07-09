//
// MSFBasicViewModel.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFBasicViewModel.h"
#import "MSFFormsViewModel.h"

@interface MSFBasicViewModel ()

@property(nonatomic,readonly) MSFFormsViewModel *viewModel;

@end

@implementation MSFBasicViewModel

- (instancetype)initWithViewModel:(id)viewModel {
  self = [super init];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
  
  return self;
}

@end
