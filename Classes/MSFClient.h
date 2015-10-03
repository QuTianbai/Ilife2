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
 *	用户手机号登录
 *
 *	@param user			Use `userWithName:phone:` to create
 *	@param password
 *	@param phone
 *
 *	@return authenticated client, Has token and user
 */
+ (RACSignal *)signInAsUser:(MSFUser *)user password:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha;

/**
 *  用户身份证登录
 *
 *  @param user     user contain server
 *  @param username user realname
 *  @param password user password
 *  @param idcard   user id card number
 *
 *  @return client with authenticated user, token
 */
+ (RACSignal *)signInAsUser:(MSFUser *)user username:(NSString *)username password:(NSString *)password citizenID:(NSString *)idcard;

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
+ (RACSignal *)signUpAsUser:(MSFUser *)user password:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha __deprecated_msg("Use `signUpAsUser: password:phone:captcha:realname:citizenID:citizenIDExpiredDate:");

/**
 *  2.0 版本注册
 *
 *  @param user        user witch contain api server
 *  @param password    The password
 *  @param phone       The phone number
 *  @param captcha     The captcha number
 *  @param realname    The user Chinese name
 *  @param citizenID   The User citizen ID Number
 *  @param expiredDate The User citizen ID number expired date, The Max value is 2099-12-31
 *
 *  @return authenticated client with user and token
 */
+ (RACSignal *)signUpAsUser:(MSFUser *)user password:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha realname:(NSString *)realname citizenID:(NSString *)citizenID citizenIDExpiredDate:(NSDate *)expiredDate;

/**
 *	退出登录
 *
 *	@return unauthenticated client, without token
 */
- (RACSignal *)signOut;

- (RACSignal *)realnameAuthentication:(NSString *)name idcard:(NSString *)idcard expire:(NSDate *)date session:(BOOL)session	province:(NSString *)provinceCode city:(NSString *)cityCode bank:(NSString *)bankCode card:(NSString *)card __deprecated_msg("Unused");

// 用户加密
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

- (RACSignal *)setTradePwdWithPWD:(NSString *)pwd AndCaptch:(NSString *)capthch;

- (RACSignal *)updateTradePwdWitholdPwd:(NSString *)oldpwd AndNewPwd:(NSString *)pwd AndCaptch:(NSString *)captch;

- (RACSignal *)resetTradepwdWithBankCardNo:(NSString *)bankCardNO AndprovinceCode:(NSString *)provinceCode AndcityCode:(NSString *)cityCode AndsmsCode:(NSString *)smsCode AndnewTransPassword:(NSString *)newTransPassword;

@end
