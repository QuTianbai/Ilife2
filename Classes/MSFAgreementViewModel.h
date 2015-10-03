//
// MSFAgreementViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class MSFAgreement;
//@class MSFProduct;
@class MSFApplyCashVIewModel;

@interface MSFAgreementViewModel : RVMViewModel

@property (nonatomic, strong, readonly) MSFAgreement *agreement;

- (instancetype)initWithModel:(MSFAgreement *)agreement;
- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

- (RACSignal *)registerAgreementSignal;
- (RACSignal *)aboutAgreementSignal;
- (RACSignal *)productAgreementSignal;
- (RACSignal *)usersAgreementSignal;
- (RACSignal *)branchAgreementSignal;
- (RACSignal *)loanAgreementSignalWithViewModel:(MSFApplyCashVIewModel *)product;

@end
