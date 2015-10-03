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
@class MSFAgreementViewModel;

@class MSFApplyCashVIewModel;

@class MSFApplyCashVIewModel;

@interface MSFLoanAgreementViewModel : RVMViewModel

@property (nonatomic, strong, readonly) MSFAgreementViewModel *agreementViewModel;
@property (nonatomic, strong, readonly) MSFApplyCashVIewModel *formsViewModel;
@property (nonatomic, strong, readonly) MSFApplyCashVIewModel *product;
@property (nonatomic, strong, readonly) RACCommand *executeRequest;
@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

- (instancetype)initWithFromsViewModel:(MSFApplyCashVIewModel *)formsViewModel;

@end
