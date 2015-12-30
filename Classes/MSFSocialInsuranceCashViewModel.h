//
//  MSFSocialInsuranceCashViewModel.h
//  Finance
//
//  Created by xbm on 15/11/20.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"
#import "MSFSelectKeyValues.h"
#import "MSFApplicationViewModel.h"

@class RACCommand;
@class MSFSocialInsuranceModel;
@class MSFApplicationForms;

@interface MSFSocialInsuranceCashViewModel : RVMViewModel <MSFApplicationViewModel>

@property (nonatomic, copy) NSString *productCd;
@property (nonatomic, strong) NSArray *accessoryInfoVOArray;
@property (nonatomic, strong) NSArray *accessories;
@property (nonatomic, copy) NSString *status;

@property (nonatomic, strong) MSFSocialInsuranceModel *model;

// 贷款信息
@property (nonatomic, strong, readonly) MSFSelectKeyValues *purpose; // 贷款用途
@property (nonatomic, copy, readonly) NSString *purposeString;
@property (nonatomic, assign, readonly) BOOL joinInsurance; // 是否加入寿险
// 身份信息
@property (nonatomic, copy, readonly) NSString *liveArea; // 居住地区
//@property (nonatomic, copy, readonly) NSString *liveAddress; // 居住地址
// 职业信息
//@property (nonatomic, copy, readonly) NSString *companyName; //公司名称
@property (nonatomic, copy, readonly) NSString *companyArea; //公司地区
//@property (nonatomic, copy, readonly) NSString *companyAddress; //公司地址
// 联系人信息
//@property (nonatomic, strong, readonly) MSFSelectKeyValues *relation; // 联系人关系
//@property (nonatomic, copy, readonly) NSString *relationString;
//@property (nonatomic, copy, readonly) NSString *name; //公司名称
//@property (nonatomic, copy, readonly) NSString *mobile; //公司名称
// 社保信息
@property (nonatomic, strong, readonly) MSFSelectKeyValues *basicPayment;
@property (nonatomic, copy, readonly) NSString *paymentString;

//RACCommand
@property (nonatomic, strong, readonly) RACCommand *executePurposeCommand;
@property (nonatomic, strong, readonly) RACCommand *executeInsuranceCommand;
@property (nonatomic, strong, readonly) RACCommand *executeRelationCommand;
@property (nonatomic, strong, readonly) RACCommand *executeLiveAddressCommand;
@property (nonatomic, strong, readonly) RACCommand *executeCompAddressCommand;
@property (nonatomic, strong, readonly) RACCommand *executeBasicPaymentCommand;
@property (nonatomic, strong, readonly) RACCommand *executeSubmitCommand;

- (instancetype)initWithServices:(id<MSFViewModelServices>)services;

@property (nonatomic, weak) id <MSFViewModelServices> services;
@property (nonatomic, strong) MSFFormsViewModel *formViewModel;
@property (nonatomic, strong) NSString *applicationNo;
@property (nonatomic, strong) MSFLoanType *loanType;

- (instancetype)initWithFormsViewModel:(MSFFormsViewModel *)formsViewModel loanType:(MSFLoanType *)loanType services:(id <MSFViewModelServices>)services;

@end
