//
// MSFInventoryViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"
#import "MSFApplicationViewModel.h"

@class MSFFormsViewModel;
@class RACCommand;
@class MSFProduct;
@class MSFApplicationResponse;
@class MSFApplyCashViewModel;
@class MSFSocialInsuranceCashViewModel;
@class MSFAttachment;

@interface MSFInventoryViewModel : RVMViewModel

// MSFElementViewModel viewModels
@property (nonatomic, strong, readonly) NSArray *viewModels;

@property (nonatomic, strong, readonly) NSArray *requiredViewModels;
@property (nonatomic, strong, readonly) NSArray *optionalViewModels;

@property (nonatomic, weak, readonly) id <MSFApplicationViewModel> applicationViewModel;

@property (nonatomic, strong, readonly) RACCommand *executeUpdateCommand;
@property (nonatomic, strong, readonly) RACCommand *executeSubmitCommand;

- (RACSignal *)updateValidSignal;

- (instancetype)initWithApplicationViewModel:(id <MSFApplicationViewModel>)applicaitonViewModel;
- (instancetype)initWithApplicationViewModel:(id <MSFApplicationViewModel>)applicaitonViewModel AndAttachment:(MSFAttachment *)attachment;
// 重新提交附件信息
- (instancetype)initWithApplicaitonNo:(NSString *)applicaitonNo productID:(NSString *)productID services:(id <MSFViewModelServices>)services;

@end
