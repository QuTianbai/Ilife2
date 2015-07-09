//
// MSFLoanAgreementViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFFormsViewModel;
@class MSFApplyCash;
@class MSFMonths;
@class RACCommand;

@interface MSFLoanAgreementViewModel : RVMViewModel

@property(nonatomic,readonly) MSFFormsViewModel *formsViewModel;
@property(nonatomic,strong) MSFApplyCash *applyCash;
@property(nonatomic,strong,readonly) MSFMonths *product;

- (instancetype)initWithFromsViewModel:(MSFFormsViewModel *)formsViewModel product:(MSFMonths *)product;

/**
 * 申请贷款
 */
@property(nonatomic,strong,readonly) RACCommand *executeRequest;

@end
