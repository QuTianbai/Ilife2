//
// MSFUtils.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSFClient;
@class MSFServer;
@class RACSignal;
@class MSFAgreementViewModel;

@interface MSFUtils : NSObject

//	设置数据请求，启动程序需要服务器最新的时间戳，然后再载入界面
//
// Returns an signal after fetch server timestamp
+ (RACSignal *)setupSignal;

// The global use client
//
// Returns MSFClient instance
+ (MSFClient *)httpClient;

// The global Server
+ (MSFServer *)server;

// The global agreement viewModel
+ (MSFAgreementViewModel *)agreementViewModel;

//	登录 需要更新这里的client以保证client是授权的
//	退出登录 需要设置为nil,检测到其他设备登录的时候都应该设置为nil
//
//	httpClient -  Update global http request client
+ (void)setHttpClient:(MSFClient *)httpClient;

// 存储用户登录手机号
+ (void)setPhone:(NSString *)phone;
+ (NSString *)phone;

// 存储用户注册手机号
+ (void)setRegisterPhone:(NSString *)phone;
+ (NSString *)registerPhone;

// Save test user update baseURL `Unused`
+ (void)setBaseURLString:(NSString *)url;
+ (NSString *)baseURLString;

//用户id
+ (NSString *)uniqueId;

//交易密码
+ (void)setTradePassword:(NSString *)isSetTradePassword;
+ (NSString *)isSetTradePassword;

//是否支持循环现金贷
+ (NSString *)isCircuteCash;

//产品群编码
+ (NSString *)productCode;

@end

