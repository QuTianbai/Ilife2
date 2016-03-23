//
// MSFLoanAgreementViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"
#import "MSFApplicationViewModel.h"

@class RACCommand;

@interface MSFLoanAgreementViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, weak, readonly) id <MSFApplicationViewModel> applicationViewModel;

// 同意贷款协议，进入头像拍照界面
@property (nonatomic, strong, readonly) RACCommand *executeAcceptCommand;

- (instancetype)initWithApplicationViewModel:(id <MSFApplicationViewModel>)applicationViewModel;
- (RACSignal *)loanAgreementSignal;

@end
