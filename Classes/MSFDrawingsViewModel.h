//
//  MSFDrawCashViewModel.h
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"
#import "MSFTransactionsViewModel.h"

@class RACCommand;

// 提款
@interface MSFDrawingsViewModel : RVMViewModel <MSFTransactionsViewModel>

@property (nonatomic, assign, readonly) id<MSFViewModelServices>services;
@property (nonatomic, strong, readonly) id model;
@property (nonatomic, strong, readonly) NSString *bankIco;
@property (nonatomic, strong, readonly) NSString *bankName;
@property (nonatomic, strong, readonly) NSString *bankNo;
@property (nonatomic, strong, readonly) NSString *summary;
@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *supports;
@property (nonatomic, strong, readwrite) NSString *amounts;
@property (nonatomic, assign, readonly) BOOL editable;
@property (nonatomic, strong, readonly) NSString *captcha;
@property (nonatomic, strong, readonly) NSString *captchaTitle;
@property (nonatomic, assign, readonly) BOOL captchaWaiting;
@property (nonatomic, strong, readonly) NSString *uniqueTransactionID;
@property (nonatomic, strong) NSString *transactionPassword;
@property (nonatomic, strong, readonly) NSString *buttonTitle;
@property (nonatomic, assign, readonly) BOOL isOutTime;

@property (nonatomic, strong, readonly) RACCommand *executeSwitchCommand;
@property (nonatomic, strong, readonly) RACCommand *executeCaptchaCommand;
@property (nonatomic, strong, readonly) RACCommand *executePaymentCommand;

- (instancetype)initWithViewModel:(id)model services:(id <MSFViewModelServices>)services;

@end
