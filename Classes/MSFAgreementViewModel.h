//
// MSFAgreementViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFAgreement;
@class MSFClient;

@interface MSFAgreementViewModel : RVMViewModel

@property(nonatomic,strong,readonly) MSFClient *client;

- (instancetype)initWithModel:(MSFAgreement *)agreement;

- (RACSignal *)registerAgreementSignal;
- (RACSignal *)aboutAgreementSignal;
- (RACSignal *)productAgreementSignal;
- (RACSignal *)usersAgreementSignal;
- (RACSignal *)branchAgreementSignal;
- (RACSignal *)loanAgreementSignal;
- (RACSignal *)repayAgreementSignal;

@end
