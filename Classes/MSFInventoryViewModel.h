//
// MSFInventoryViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class MSFFormsViewModel;
@class RACCommand;
@class MSFProduct;
@class MSFApplicationResponse;
@class MSFApplyCashVIewModel;
@class MSFSocialInsuranceCashViewModel;

@interface MSFInventoryViewModel : RVMViewModel

// MSFElementViewModel viewModels
@property (nonatomic, strong, readonly) NSArray *viewModels;

@property (nonatomic, strong, readonly) NSArray *requiredViewModels;
@property (nonatomic, strong, readonly) NSArray *optionalViewModels;

@property (nonatomic, strong, readonly) RACCommand *executeUpdateCommand;

// 用于提交马上贷信息
@property (nonatomic, weak, readonly) MSFApplyCashVIewModel *formsViewModel;

// 用于提交社保信息
@property (nonatomic, weak, readonly) MSFSocialInsuranceCashViewModel *insuranceViewModel;

// 提交命令
@property (nonatomic, strong, readonly) RACCommand *executeSubmitCommand;

- (RACSignal *)updateValidSignal;

// 马上贷
- (instancetype)initWithCashViewModel:(MSFApplyCashVIewModel *)cashViewModel;

// 社保贷
- (instancetype)initWithInsuranceViewModel:(MSFSocialInsuranceCashViewModel *)insuranceViewModel;

// 从新提交附件信息
- (instancetype)initWithApplicaitonNo:(NSString *)applicaitonNo productID:(NSString *)productID services:(id <MSFViewModelServices>)services;

@end
