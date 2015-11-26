//
// MSFLoanAgreementViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"
#import "MSFApplicationViewModel.h"

@class MSFFormsViewModel;
@class MSFApplicationResponse;
@class MSFProduct;
@class RACCommand;
@class MSFAddress;
@class MSFAgreementViewModel;
@class MSFApplyCashVIewModel;

@interface MSFLoanAgreementViewModel : RVMViewModel

@property (nonatomic, strong, readonly) RACCommand *executeRequest;

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, weak, readonly) id <MSFApplicationViewModel> applicationViewModel;

- (instancetype)initWithApplicationViewModel:(id <MSFApplicationViewModel>)applicationViewModel;
- (RACSignal *)loanAgreementSignal;

@end
