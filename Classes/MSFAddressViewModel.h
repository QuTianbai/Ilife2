//
// MSFAddressViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFAreas;
@class RACCommand;
@class UIViewController;

@interface MSFAddressViewModel : RVMViewModel

@property(nonatomic,strong) MSFAreas *province;
@property(nonatomic,strong) MSFAreas *city;
@property(nonatomic,strong) MSFAreas *area;

@property(nonatomic,strong) RACCommand *selectCommand;

@property(nonatomic,strong,readonly) NSString *address;

@property(nonatomic,strong,readonly) UIViewController *viewController;

- (instancetype)initWithController:(UIViewController *)viewController;

@end
