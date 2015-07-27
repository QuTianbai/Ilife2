//
// MSFLoanAgreementViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class MSFFormsViewModel;
@class MSFApplicationResponse;
@class MSFProduct;
@class RACCommand;
@class MSFAddress;

@interface MSFLoanAgreementViewModel : RVMViewModel

@property (nonatomic, strong, readonly) MSFFormsViewModel *formsViewModel;
@property (nonatomic, strong, readonly) MSFApplicationResponse *applyCash;
@property (nonatomic, strong, readonly) MSFProduct *product;
@property (nonatomic, strong, readonly) RACCommand *executeRequest;
@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

- (instancetype)initWithFromsViewModel:(MSFFormsViewModel *)formsViewModel product:(MSFProduct *)product;

@end
