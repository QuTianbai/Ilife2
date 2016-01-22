//
// MSFPaymentViewModel.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACCommand;

@protocol MSFTransactionsViewModel <NSObject>

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

// 获取验证码
@property (nonatomic, strong, readonly) NSString *executeCaptchaCommand;

// 支持银行提示语
@property (nonatomic, strong, readonly) NSString *supports;

// 金额
@property (nonatomic, strong, readonly) NSString *amounts;

// 支付/还款
@property (nonatomic, strong, readonly) RACCommand *executePaymentCommand;

// 提款
@property (nonatomic, strong, readonly) RACCommand *executeWithdrawCommand;

@end
