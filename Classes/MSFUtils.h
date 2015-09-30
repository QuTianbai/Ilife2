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

/**
 *	设置数据请求，启动程序需要服务器最新的时间戳，然后再载入界面
 *
 *	@return MSFResponse instantce
 */
+ (RACSignal *)setupSignal;

/**
 *	全局通用Client
 *
 *	@return MSFClient instance
 */
+ (MSFClient *)httpClient;

/**
 *	The Server
 */
+ (MSFServer *)server;

/**
 *	程序相关协议
 */
+ (MSFAgreementViewModel *)agreementViewModel;

/**
 *	登录 需要更新这里的client以保证client是授权的
 *	退出登录 需要设置为nil,检测到其他设备登录的时候都应该设置为nil
 *
 *	@param httpClient
 */
+ (void)setHttpClient:(MSFClient *)httpClient;

/**
 *	用户登录手机号
 */
+ (void)setPhone:(NSString *)phone;
+ (NSString *)phone;

/**
 * 用户注册手机号
 */
+ (void)setRegisterPhone:(NSString *)phone;
+ (NSString *)registerPhone;

+ (void)setBaseURLString:(NSString *)url;
+ (NSString *)baseURLString;

@end