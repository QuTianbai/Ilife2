//
// MSFAddressViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class MSFAddress;
@class RACCommand;
@class MSFApplicationForms;
@class MSFAddressCodes;

@interface MSFAddressViewModel : RVMViewModel

@property (nonatomic, strong) MSFAddress *province;
@property (nonatomic, strong) MSFAddress *city;
@property (nonatomic, strong) MSFAddress *area;

@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSString *provinceCode;

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *cityCode;

@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) NSString *areaCode;

@property (nonatomic, strong) RACCommand *selectCommand;

@property (nonatomic, strong, readonly) NSString *address;
@property (nonatomic, strong) NSString *detailAddress;

@property (nonatomic, assign, readonly) BOOL needArea;
@property (nonatomic, assign) BOOL isStopAutoLocation;

// 通过这个方法创建的viewmodel忽略区的选择
- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

// 使用外面的地址信息创建viewModel,在这个初始化方法中，需要选择区
//
// address	- 传入的地址信息，默认nil address `省ID 城市ID 区域ID`
// services - 服务用于加载城市选择控制器
//
// return new viewModel
- (instancetype)initWithAddress:(MSFAddressCodes *)address services:(id <MSFViewModelServices>)services;

@end
