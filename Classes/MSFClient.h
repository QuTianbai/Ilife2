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

// json解析错误
extern const NSInteger MSFClientErrorJSONParsingFailed;

// 认证错误
extern const NSInteger MSFClientErrorAuthenticationFailed;
extern NSString *const MSFClientErrorAuthenticationFailedNotification;

@interface MSFClient : AFHTTPRequestOperationManager

/**
 * 添加request到请求队列
 *
 *	@param request		 The request
 *	@param resultClass The result Class
 *
 *	@return `requestClass == nil will return MSFResponse instance`
 */
- (RACSignal *)enqueueRequest:(NSURLRequest *)request resultClass:(Class)resultClass;

/**
 *	添加与用户相关的请求到队列
 *
 *	@param method				GET POST PUT DELETE
 *	@param relativePath it must start with `/`
 *	@param parameters		参数
 *	@param resultClass	The result class
 *
 *	@return `requestClass == nil will return MSFResponse instance`
 */
- (RACSignal *)enqueueUserRequestWithMethod:(NSString *)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters resultClass:(Class)resultClass;

/**
 *	创建Client的方法
 *
 *	@param server MSFServer.dotComServer
 *
 *	@return client instance
 */
- (instancetype)initWithServer:(MSFServer *)server;

@property (nonatomic, strong, readonly) MSFUser *user;
@property (nonatomic, copy, readonly) NSString *token;
@property (nonatomic, copy, readonly) NSString *session;

@property (nonatomic, readonly, getter = isAuthenticated) BOOL authenticated;

/**
 *	创建未授权的Client
 *
 *	@param user 用户信息 Use `userWithName:phone:` to create
 *
 *	@return client
 */
+ (instancetype)unauthenticatedClientWithUser:(MSFUser *)user;

/**
 *	创建授权的Client
 *
 *	@param user	 User must contain objectID
 *	@param token 服务器返回的token
 *
 *	@return Client
 */
+ (instancetype)authenticatedClientWithUser:(MSFUser *)user token:(NSString *)token session:(NSString *)session;

/**
 *	登录
 *
 *	@param user			Use `userWithName:phone:` to create
 *	@param password
 *	@param phone
 *
 *	@return authenticated client, Has token and user
 */
+ (RACSignal *)signInAsUser:(MSFUser *)user password:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha;

/**
 *	注册
 *
 *	@param user			Use `userWithName:phone:` to create
 *	@param password
 *	@param phone
 *	@param captcha	短信验证码
 *
 *	@return authenticated client, Has token and user
 */
+ (RACSignal *)signUpAsUser:(MSFUser *)user password:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha;

/**
 *	退出登录
 *
 *	@return unauthenticated client, without token
 */
- (RACSignal *)signOut;

- (RACSignal *)realnameAuthentication:(NSString *)name idcard:(NSString *)idcard expire:(NSDate *)date session:(BOOL)session	province:(NSString *)provinceCode city:(NSString *)cityCode bank:(NSString *)bankCode card:(NSString *)card;

+ (void)setCipher:(MSFCipher *)cipher;
+ (MSFCipher *)cipher;

@end

@interface MSFClient (Requests)

/**
 *	Create JSON Requests
 *
 *	@param method			GET POST
 *	@param path				The path
 *	@param parameters
 *
 *	@return NSMutableURLRequest instance
 */
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(id)parameters;
- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void(^)(id <AFMultipartFormData> formData))block;

- (RACSignal *)addBankCardWithTransPassword:(NSString *)transPassword AndBankCardNo:(NSString *)bankCardNo AndbankBranchProvinceCode:(NSString *)bankBranchProvinceCode AndbankBranchCityCode:(NSString *)bankBranchCityCode;

- (RACSignal *)setMasterBankCard:(NSString *)bankCardID AndTradePwd:(NSString *)pwd;

- (RACSignal *)unBindBankCard:(NSString *)bankCardID AndTradePwd:(NSString *)pwd;

- (RACSignal *)drawCashWithDrawCount:(NSString *)count AndContraceNO:(NSString *)contractNO AndType:(int)type;

@end
