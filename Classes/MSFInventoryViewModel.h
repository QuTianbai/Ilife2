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

@interface MSFInventoryViewModel : RVMViewModel

@property (nonatomic, strong, readonly) MSFInventory *model;
@property (nonatomic, strong, readonly) MSFProduct *product;
@property (nonatomic, strong, readonly) MSFApplicationResponse *credit;

@property (nonatomic, strong, readonly) NSArray *attachments;

// MSFElementViewModel viewModels
@property (nonatomic, strong, readonly) NSArray *viewModels;

@property (nonatomic, strong, readonly) RACCommand *executeUpdateCommand;
//@property (nonatomic, strong, readonly) RACSignal *updatedContentSignal;

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel;

@end
