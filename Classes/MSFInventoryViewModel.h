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
@class MSFProduct;
@class MSFApplicationResponse;
@class MSFApplyCashVIewModel;

@interface MSFInventoryViewModel : RVMViewModel

@property (nonatomic, strong, readonly) MSFInventory *model;
@property (nonatomic, strong) MSFApplyCashVIewModel *cashViewModel;

// MSFElementViewModel viewModels
@property (nonatomic, strong, readonly) NSArray *viewModels;

@property (nonatomic, strong, readonly) NSArray *requiredViewModels;
@property (nonatomic, strong, readonly) NSArray *optionalViewModels;

@property (nonatomic, strong, readonly) RACCommand *executeUpdateCommand;
@property (nonatomic, strong, readonly) RACSignal *updatedContentSignal;

@property (nonatomic, strong, readonly) RACCommand *executeSubmit;

- (RACSignal *)updateValidSignal;

- (instancetype)initWithFormsViewModel:(MSFApplyCashVIewModel *)formsViewModel;

@end
