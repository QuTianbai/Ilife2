//
// MSFInventoryViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class MSFFormsViewModel;
@class RACCommand;
@class MSFInventory;

@interface MSFInventoryViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, strong, readonly) MSFInventory *model;

@property (nonatomic, strong, readonly) RACCommand *executeUpdateCommand;

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel;

@end
