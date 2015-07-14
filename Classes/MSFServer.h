//
// MSFServer.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MTLModel.h"

/**
 *	服务器
 */
@interface MSFServer : MTLModel

/**
 *	The baseURL
 */
@property (nonatomic, copy, readonly) NSURL *baseURL;

/**
 *	API 调用URL
 */
@property (nonatomic, copy, readonly) NSURL *APIEndpoint;

/**
 *	WebView 基本URL
 */
@property (nonatomic, copy, readonly) NSURL *baseWebURL;

/**
 *	默认服务器地址,不包含接口版本信息
 *
 *	@return server
 */
+ (instancetype)dotComServer;

/**
 *	初始化服务器
 *
 *	@param baseURL 如果baseURL不为空，将返回带接口版本的APIEndpoint
 *
 *	@return server
 */
+ (instancetype)serverWithBaseURL:(NSURL *)baseURL;

@end
