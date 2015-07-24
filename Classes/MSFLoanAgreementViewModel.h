//
// MSFLoanAgreementViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFFormsViewModel;
@class MSFApplicationResponse;
@class MSFProduct;
@class RACCommand;

@interface MSFLoanAgreementViewModel : RVMViewModel

@property (nonatomic, readonly) MSFFormsViewModel *formsViewModel;
@property (nonatomic, strong) MSFApplicationResponse *applyCash;
@property (nonatomic, strong, readonly) MSFProduct *product;
@property (nonatomic, strong, readonly) RACCommand *executeRequest;

- (instancetype)initWithFromsViewModel:(MSFFormsViewModel *)formsViewModel product:(MSFProduct *)product;

@end
