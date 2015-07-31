//
// MSFAddressViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class MSFAreas;
@class RACCommand;
@class MSFApplicationForms;
@class MSFAddress;

@interface MSFAddressViewModel : RVMViewModel

@property (nonatomic, strong) MSFAreas *province;
@property (nonatomic, strong) MSFAreas *city;
@property (nonatomic, strong) MSFAreas *area;

@property (nonatomic, strong) NSString *provinceName;
@property (nonatomic, strong) NSString *provinceCode;

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *cityCode;

@property (nonatomic, strong) NSString *areaName;
@property (nonatomic, strong) NSString *areaCode;

@property (nonatomic, strong) RACCommand *selectCommand;

@property (nonatomic, strong, readonly) NSString *address;

@property (nonatomic, assign, readonly) BOOL needArea;
@property (nonatomic, assign) BOOL isStopAutoLocation;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;
- (instancetype)initWithAddress:(MSFAddress *)address services:(id <MSFViewModelServices>)services;

@end
