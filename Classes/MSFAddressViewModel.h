//
// MSFAddressViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFAreas;
@class RACCommand;
@class UIViewController;
@class MSFApplicationForms;

@interface MSFAddressViewModel : RVMViewModel

@property(nonatomic,strong) MSFAreas *province;
@property(nonatomic,strong) MSFAreas *city;
@property(nonatomic,strong) MSFAreas *area;

@property(nonatomic,strong) NSString *provinceName;
@property(nonatomic,strong) NSString *provinceCode;

@property(nonatomic,strong) NSString *cityName;
@property(nonatomic,strong) NSString *cityCode;

@property(nonatomic,strong) NSString *areaName;
@property(nonatomic,strong) NSString *areaCode;

@property(nonatomic,strong) RACCommand *selectCommand;

@property(nonatomic,strong,readonly) NSString *address;

@property(nonatomic,assign,readonly) BOOL needArea;

@property(nonatomic,weak,readonly) UIViewController *viewController;

- (instancetype)initWithController:(UIViewController *)viewController;
- (instancetype)initWithController:(UIViewController *)viewController needArea:(BOOL)needArea;

//TODO: 改进这里的初始化方法
// 当前地址选择
- (instancetype)initWithApplicationForm:(MSFApplicationForms *)model controller:(UIViewController *)viewController;

// 工作地址选择
- (instancetype)initWithWorkApplicationForm:(MSFApplicationForms *)model controller:(UIViewController *)viewController;

@end
