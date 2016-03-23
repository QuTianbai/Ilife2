//
// MSFPaymentViewModel.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MSFViewModelServices.h"

@class RACCommand;

@protocol MSFTransactionsViewModel <NSObject>

// 服务
@property (nonatomic, assign, readonly) id<MSFViewModelServices>services;

// 模型数据
@property (nonatomic, strong, readonly) id model;

// 银行卡图标
@property (nonatomic, strong, readonly) NSString *bankIco;

// 银行名称
@property (nonatomic, strong, readonly) NSString *bankName;

// 银行卡后四位
@property (nonatomic, strong, readonly) NSString *bankNo;

// 更换银行卡
@property (nonatomic, strong, readonly) RACCommand *executeSwitchCommand;

// 提示款项信息
@property (nonatomic, strong, readonly) NSString *summary;

// 支付控制器标题
@property (nonatomic, strong, readonly) NSString *title;

// 手机验证码
@property (nonatomic, strong, readonly) NSString *captcha;
@property (nonatomic, strong, readonly) NSString *captchaTitle;
@property (nonatomic, assign, readonly) BOOL captchaWaiting;


// 获取验证码
@property (nonatomic, strong, readonly) RACCommand *executeCaptchaCommand;

// 支持银行提示语
@property (nonatomic, strong, readonly) NSString *supports;

// 金额
@property (nonatomic, strong, readwrite) NSString *amounts;

// 金额是否可编辑 (还款状态下不可编辑)
@property (nonatomic, assign, readonly) BOOL editable;
//未到还款日
@property (nonatomic, strong, readonly) NSString *buttonTitle;
//是否逾期
@property (nonatomic, assign, readonly) BOOL isOutTime;

// 发起短信验证码的时候获取的交易流水唯一号
@property (nonatomic, strong, readonly) NSString *uniqueTransactionID;

// 交易密码，用户输入
@property (nonatomic, strong) NSString *transactionPassword;

@optional
// 支付/还款
@property (nonatomic, strong, readonly) RACCommand *executePaymentCommand;

// 提款
@property (nonatomic, strong, readonly) RACCommand *executeWithdrawCommand;

@end
