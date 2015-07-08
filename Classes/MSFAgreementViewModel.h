//
// MSFAgreementViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFAgreement;
@class MSFClient;
@class MSFMonths;

@interface MSFAgreementViewModel : RVMViewModel

@property(nonatomic,strong,readonly) MSFClient *client;
@property(nonatomic,strong,readonly) MSFAgreement *agreement;

- (instancetype)initWithModel:(MSFAgreement *)agreement;

- (RACSignal *)registerAgreementSignal;
- (RACSignal *)aboutAgreementSignal;
- (RACSignal *)productAgreementSignal;
- (RACSignal *)usersAgreementSignal;
- (RACSignal *)branchAgreementSignal;
- (RACSignal *)loanAgreementSignal __deprecated_msg("Use `-loanAgreementSignalWithProduct:`");
- (RACSignal *)repayAgreementSignal;
- (RACSignal *)loanAgreementSignalWithProduct:(MSFMonths *)product;

@end
