//
// MSFClient.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@class RACSignal;
@class MSFServer;
@class MSFUser;
@class MSFCipher;

// 错误域
extern NSString *const MSFClientErrorDomain;

// HTTP状态码
// json解析错误
extern const NSInteger MSFClientErrorJSONParsingFailed;

// HTTP状态码
// 认证错误
extern const NSInteger MSFClientErrorAuthenticationFailed;

extern NSString *const MSFClientErrorAuthenticationFailedNotification;

// HTTP状态码
// 验证通过用户没有访问权限
extern const NSInteger MSFClientErrorForbidden;

// HTTP状态码
// 资源未找到
extern const NSInteger MSFClientErrorNotFound;

// HTTP状态码
// POST/PUT/PATCH请求没有带上application/json类型
extern const NSInteger MSFClientErrorUnsupportedMediaType;

// 验证错误
// 如果在POST/PUT/PATCH请求时发生入参验证错误, 会返回验证错误422 Unprocessable Entry状态码。json返回的body中会包含一个错误信息数组。
extern NSString *const MSFClientErrorFieldKey;

// 当发生错误的时候，返回的json字典中的`code`
extern NSString *const MSFClientErrorMessageCodeKey;

// 当发生错误的时候，返回的json字典中的`message`
extern NSString *const MSFClientErrorMessageKey;

// HTTP状态码
// 由于一个验证错误导致请求修改或创建资源失败
extern const NSInteger MSFClientErrorUnprocessableEntry;

// HTTP状态码
// 请求无法解析
extern const NSInteger MSFClientErrorBadRequest;

// HTTP状态码
// 由于速度限制请求被拒绝
extern const NSInteger MSFClientErrorTooManyRequests;

@interface MSFClient : AFHTTPRequestOperationManager

// 添加request到请求队列
//
// request		 - The request
// resultClass - The result Class
//
// Returns `requestClass == nil will return MSFResponse instance`
- (RACSignal *)enqueueRequest:(NSURLRequest *)request resultClass:(Class)resultClass;

// 添加与用户相关的请求到队列
//
//  method			 - GET POST PUT DELETE
//  relativePath - it must start with `/`
//  parameters	 - 参数
//  resultClass	 - The result class
//
// Returns `requestClass == nil will return MSFResponse instance`
- (RACSignal *)enqueueUserRequestWithMethod:(NSString *)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters resultClass:(Class)resultClass;

// 创建Client的方法
//
// server - MSFServer.dotComServer
//
// Returns client instance
- (instancetype)initWithServer:(MSFServer *)server;

// Authenticated user
@property (nonatomic, strong, readonly) MSFUser *user;

// Service request headers `token`
@property (nonatomic, copy, readonly) NSString *token;

// Client authenticated with `user`
@property (nonatomic, readonly, getter = isAuthenticated) BOOL authenticated;

// 创建未授权的Client
//
// user - 用户信息 Use `userWithName:phone:` to create
//
// Returns client
+ (instancetype)unauthenticatedClientWithUser:(MSFUser *)user;

// 创建授权的Client
//
// user	 - User must contain objectID
// token - 服务器返回的token
//
// Returns Client
+ (instancetype)authenticatedClientWithUser:(MSFUser *)user token:(NSString *)token;

// 用户手机号登录
//
// user			- Use `userWithServer:` create unauthenticated user
// password - User password
// phone	  - The User Phone number
// captcha	- Option, When User login in different device
//
// Returns authenticated client, Has token and user
+ (RACSignal *)signInAsUser:(MSFUser *)user password:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha;

// 用户身份证登录
//
// user     - user contain server
// username - user realname
// password - user password
// idcard   - user id card number
//
// Returns client with authenticated user, token
+ (RACSignal *)signInAsUser:(MSFUser *)user username:(NSString *)username password:(NSString *)password citizenID:(NSString *)idcard;

// 2.0 版本注册
//
// user        - user witch contain api server
// password    - The password
// phone       - The phone number
// captcha     - The captcha number
// realname    - The user Chinese name
// citizenID   - The User citizen ID Number
// expiredDate - The User citizen ID number expired date, The Max value is 2099-12-31
//
// Returns authenticated client with user and token
+ (RACSignal *)signUpAsUser:(MSFUser *)user password:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha realname:(NSString *)realname citizenID:(NSString *)citizenID citizenIDExpiredDate:(NSDate *)expiredDate;

// 退出登录
//
// Returns unauthenticated client, without token
- (RACSignal *)signOut;

// 用户加密
+ (void)setCipher:(MSFCipher *)cipher;
+ (MSFCipher *)cipher;

@end

@interface MSFClient (Requests)

// Create forms Requests
//
// method			- `GET` `POST`
// path				- The path
// parameters - The parameters
//
// Return NSMutableURLRequest instance
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(id)parameters;

// Create mutable binary flow request
//
// method			- set POST
// path				- The request path
// parameters - request parameters
//
// Returns NSMutableURLRequest instance for submit image/file
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void(^)(id <AFMultipartFormData> formData))block;

@end
