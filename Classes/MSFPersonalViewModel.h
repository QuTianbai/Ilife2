//
// MSFBasicViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFApplicationForms;
@class MSFFormsViewModel;

 /**
  *  基本信息
  */
@interface MSFPersonalViewModel : RVMViewModel

@property(nonatomic,strong,readonly) MSFApplicationForms *model;

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)viewModel;

@end
