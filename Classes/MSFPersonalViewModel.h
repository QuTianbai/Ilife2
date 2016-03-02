//
// MSFBasicViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//
// 基本信息

#import "RVMViewModel.h"
#import "MSFReactiveView.h"
#import "MSFViewModelServices.h"

@class MSFApplicationForms;
@class RACCommand;

@interface MSFPersonalViewModel : RVMViewModel <MSFReactiveView>

@property (nonatomic, strong) NSString *house;
@property (nonatomic, strong) NSString *marriage;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *address;//省市区
@property (nonatomic, strong) NSString *detailAddress;//省市区

@property (nonatomic, strong, readonly) RACCommand *executeAlterAddressCommand;
@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;
@property (nonatomic, strong, readonly) RACCommand *executeHouseValuesCommand;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@property (nonatomic, strong, readonly) MSFApplicationForms *forms __deprecated;
@property (nonatomic, assign, readonly) BOOL edited __deprecated;

@end
