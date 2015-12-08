//
// MSFBasicViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//
// 基本信息

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"
#import "MSFReactiveView.h"

@class MSFFormsViewModel;
@class MSFAddressViewModel;
@class RACCommand;

@interface MSFPersonalViewModel : RVMViewModel <MSFReactiveView>

@property (nonatomic, strong, readonly) NSString *address;//省市区
@property (nonatomic, strong, readonly) MSFFormsViewModel *formsViewModel;
@property (nonatomic, assign, readonly) BOOL edited;

@property (nonatomic, strong, readonly) RACCommand *executeAlterAddressCommand;
@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;
@property (nonatomic, strong, readonly) RACCommand *executeHouseValuesCommand;

@end
