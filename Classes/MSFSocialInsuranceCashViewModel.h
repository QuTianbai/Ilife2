//
//  MSFSocialInsuranceCashViewModel.h
//  Finance
//
//  Created by xbm on 15/11/20.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"
#import "MSFApplicationViewModel.h"

@class RACCommand;
@class MSFLoanType;

@interface MSFSocialInsuranceCashViewModel : RVMViewModel <MSFApplicationViewModel>

@property (nonatomic, strong, readonly) NSString *purposeTitle; // 贷款用途
@property (nonatomic, strong, readonly) NSString *address; // 地址
@property (nonatomic, strong, readonly) NSString *detailAddress; // 详细地址
@property (nonatomic, strong, readonly) NSString *radixTitle; // 保险基数
@property (nonatomic, strong, readonly) NSString *contactName; // 联系人名字
@property (nonatomic, strong, readonly) NSString *contactPhone; // 联系人手机号
@property (nonatomic, strong, readonly) NSString *liveArea; // 居住地区
@property (nonatomic, assign, readonly) BOOL joinInsurance; // 是否加入寿险
@property (nonatomic, strong, readwrite) NSString *applicationNo;
@property (nonatomic, strong, readwrite) NSString *amount;
@property (nonatomic, strong, readwrite) NSString *loanTerm;
@property (nonatomic, strong, readwrite) NSArray *accessories;
@property (nonatomic, strong, readonly) MSFLoanType *loanType;

// RACCommand
@property (nonatomic, strong, readonly) RACCommand *executePurposeCommand;
@property (nonatomic, strong, readonly) RACCommand *executeInsuranceCommand;
@property (nonatomic, strong, readonly) RACCommand *executeRelationCommand;
@property (nonatomic, strong, readonly) RACCommand *executeLiveAddressCommand;
@property (nonatomic, strong, readonly) RACCommand *executeCompAddressCommand;
@property (nonatomic, strong, readonly) RACCommand *executeBasicPaymentCommand;
@property (nonatomic, strong, readonly) RACCommand *executeSubmitCommand;

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, strong, readonly) RACCommand *executeCommitCommand;

- (instancetype)initWithServices:(id<MSFViewModelServices>)services;

@end
