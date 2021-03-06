//
// MSFBasicViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//
// 基本信息

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"
#import "MSFApplicationViewModel.h"

@class RACCommand;

@interface MSFPersonalViewModel : RVMViewModel

@property (nonatomic, strong) NSString *house;
@property (nonatomic, strong) NSString *marriage;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *detailAddress;

@property (nonatomic, strong, readonly) RACCommand *executeAlterAddressCommand;
@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;
@property (nonatomic, strong, readonly) RACCommand *executeHouseValuesCommand;

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, weak, readonly) id <MSFApplicationViewModel> viewModel;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;
- (instancetype)initWithViewModel:(id)viewModel services:(id <MSFViewModelServices>)services;

@end
