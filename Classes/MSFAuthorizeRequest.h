//
// MSFAuthorizeRequest.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

typedef enum : NSUInteger {
    MSFAuthorizeRequestSignInMobile, // 手机号登录
    MSFAuthorizeRequestSignInIdentifier, // 身份证登录
    MSFAuthorizeRequestSignUp, // 注册
    MSFAuthorizeRequestRetrievePassword, // 找回密码
    MSFAuthorizeRequestUpdatePassword, // 更新密码
    MSFAuthorizeRequestSetupTransactCode, // 设置交易密码
    MSFAuthorizeRequestRetrieveTransactCode, // 找回交易密码
    MSFAuthorizeRequestUpdateTransactCode, // 更新交易密码
    MSFAuthorizeRequestUpdateMobile, // 更新手机号
    MSFAuthorizeRequestBindCard, // 绑定银行卡
    MSFAuthorizeRequestUnbindCard, // 解绑银行卡
    MSFAuthorizeRequestMainbind, // 绑定主卡
    MSFAuthorizeRequestSignOut, // 退出
    MSFAuthorizeRequestFetchCaptcha, // 获取验证码
    MSFAuthorizeRequestCheckTransactCode, // 检查是否存在交易密码
} MSFAuthorizeRequestType;

@interface MSFAuthorizeRequest : MSFObject

// 类型
@property (nonatomic, assign) MSFAuthorizeRequestType requestType;

// 设备唯一标示符
@property (nonatomic, copy) NSString *imei;

// 手机号
@property (nonatomic, copy) NSString *mobile;

// 登录密码/旧密码
@property (nonatomic, copy) NSString *password;

// 用户真实姓名
@property (nonatomic, copy) NSString *name;

// 用户身份证号
@property (nonatomic, copy) NSString *identifier;

// 短信验证码
@property (nonatomic, copy) NSString *smscode;

// 身份证失效时间
@property (nonatomic, strong) NSDate *identifierExpiredDate;

// 用户唯一身份ID
@property (nonatomic, strong) NSString *uniqueId;

// 修改密码的时候输入的新密码
@property (nonatomic, strong) NSString *updatingPassword;

// 请求的交易密码
@property (nonatomic, strong) NSString *transactCode;

// 目前的交易密码
@property (nonatomic, strong) NSString *usingTransactCode;

// 新的交易密码
@property (nonatomic, strong) NSString *updatingTransactCode;

// 修改手机号的旧手机号
@property (nonatomic, strong) NSString *usingMobile;

// 正在使用的身份证号
@property (nonatomic, strong) NSString *usingIdentifier;

- (NSDictionary *)requestBody;

- (instancetype)initWithRequestType:(MSFAuthorizeRequestType)requestType;

@end
