//
// MSFClient.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"
#import "MSFResponse.h"
#import "MSFServer.h"
#import "MSFCipher.h"
#import "MSFUser.h"
#import "MSFClient+Users.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFAuthorization.h"
#import "MSFObject+Private.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import <Mantle/Mantle.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <OpenUDID/OpenUDID.h>
#import <libextobjc/extobjc.h>
#import <NSString-Hashes/NSString+Hashes.h>
#import "MSFUtils.h"
#import "MSFSignature.h"
#import "RCLocationManager.h"
#import <Crashlytics/Crashlytics.h>

NSString *const MSFClientErrorDomain = @"MSFClientErrorDomain";

const NSInteger MSFClientErrorJSONParsingFailed = 669;
const NSInteger MSFClientErrorAuthenticationFailed = 401;
NSString *const MSFClientErrorAuthenticationFailedNotification = @"MSFClientErrorAuthenticationFailedNotification";

const NSInteger MSFClientErrorForbidden = 403;
const NSInteger MSFClientErrorNotFound = 404;
const NSInteger MSFClientErrorUnsupportedMediaType = 415;
const NSInteger MSFClientErrorUnprocessableEntry = 422;
const NSInteger MSFClientErrorTooManyRequests = 429;
const NSInteger MSFClientErrorBadRequest = 400;

NSString *const MSFClientErrorFieldKey = @"fields";
NSString *const MSFClientErrorMessageCodeKey = @"code";
NSString *const MSFClientErrorMessageKey = @"message";

static const NSInteger MSFClientNotModifiedStatusCode = 304;

static NSString *const MSFClientResponseLoggingEnvironmentKey = @"LOG_API_RESPONSES";

static MSFCipher *cipher;

static BOOL isRunningTests(void) __attribute__((const));

static BOOL isRunningTests(void) {
	NSDictionary *environment = [[NSProcessInfo processInfo] environment];
	NSString *injectBundle = environment[@"XCInjectBundle"];
	BOOL isTestsRunning = [[injectBundle pathExtension] isEqualToString:@"xctest"] ||
	[[injectBundle pathExtension] isEqualToString:@"octest"];

	return isTestsRunning;
}

@interface MSFClient ()

@property (nonatomic, strong) NSMutableDictionary *defaultHeaders;
@property (nonatomic, strong, readwrite) MSFUser *user;
@property (nonatomic, copy, readwrite) NSString *token;
@property (nonatomic, copy, readwrite) NSString *session;

@end

@implementation MSFClient

#pragma mark - Lifecycle

- (instancetype)initWithServer:(MSFServer *)server {
	NSParameterAssert(server != nil);
	if (!(self = [super initWithBaseURL:server.APIEndpoint])) {
		return nil;
	}
	
	NSMutableDictionary *(^MFSClientDefaultHeaders)(void) = ^{
		// Device:平台 +系统版本; + 渠道; + App内部版本号; + 制造商; + 牌子; + 型号; + 编译ID; + 设备ID; + GPS(lat,lng)
		// Android 5.0; msfinance; 10001; Genymotion; generic; Google Nexus 5 - 5.0.0 - API 21 - 1080x1920; 000000000000000;
		NSDictionary *info = [NSBundle mainBundle].infoDictionary;
		NSMutableArray *devices = NSMutableArray.new;
		[devices addObject:[NSString stringWithFormat:@"iOS %@", [UIDevice currentDevice].systemVersion]];
		[devices addObject:@"appstore"];
		[devices addObject:info[@"CFBundleShortVersionString"]];
		[devices addObject:@"Apple"];
		[devices addObject:@"iPhone"];
		[devices addObject:[UIDevice currentDevice].systemName];
		[devices addObject:info[@"CFBundleVersion"]];
		[devices addObject:OpenUDID.value];
		[devices addObject:@"00"];
		NSString *cookie = [NSString stringWithFormat:@"uid=\"%@\";Domain=i.msxf.com;isHttpOnly=true", OpenUDID.value];
		
		return [@{
			@"Device": [devices componentsJoinedByString:@";"],
			@"Set-Cookie": cookie,
		} mutableCopy];
	};
	self.defaultHeaders = MFSClientDefaultHeaders();
	self.requestSerializer.timeoutInterval = 15;
	self.securityPolicy.allowInvalidCertificates = YES;
	
	if (isRunningTests()) {
		return self;
	}
	CLAuthorizationStatus const status = [CLLocationManager authorizationStatus];
	if (status > 1) {
		[[RCLocationManager sharedManager] setUserDistanceFilter:kCLLocationAccuracyKilometer];
		[[RCLocationManager sharedManager] setUserDesiredAccuracy:kCLLocationAccuracyKilometer];
		[[RCLocationManager sharedManager] startUpdatingLocationWithBlock:^(CLLocationManager *manager, CLLocation *newLocation, CLLocation *oldLocation) {
			[self setDefaultHeader:@"Device" value:[self.class deviceWithCoordinate:newLocation.coordinate]];
			[[RCLocationManager sharedManager] stopUpdatingLocation];
		} errorBlock:^(CLLocationManager *manager, NSError *error) {}];
	}
	
	return self;
}

- (id)initWithBaseURL:(NSURL *)url {
	NSAssert(NO, @"must use `initWithServer:`");
	
	return nil;
}

#pragma mark - Custom Accessors

- (void)setToken:(NSString *)token {
	_token = [token copy];
	
	if (token == nil) {
		[self clearAuthorizationHeader];
	} else {
		[self setAuthorizationHeaderWithToken:token];
	}
}

- (void)setSession:(NSString *)session {
	_session = [session copy];
	if (session == nil) {
		[self clearAuthorizationHeader];
	} else {
		[self setAuthorizationHeaderWithSession:session];
	}
}

#pragma mark - Cipher

+ (MSFCipher *)cipher {
	return cipher;
}

+ (void)setCipher:(MSFCipher *)aCipher {
	cipher = aCipher;
}

- (NSDictionary *)signatureArgumentsWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
	if (cipher) {
		MSFSignature *signature = [cipher signatureWithPath:path parameters:parameters];
		
		return parameters?[parameters mtl_dictionaryByAddingEntriesFromDictionary:signature.dictionaryValue]:signature.dictionaryValue;
	}
  
	
	return parameters;
}

- (MSFSignature *)signatureWithPath:(NSString *)path parameters:(NSDictionary *)parameters {
	if (cipher) {
		return [cipher signatureWithPath:path parameters:parameters];
	}
	
	return [[MSFSignature alloc] initWithDictionary:@{@"sign": @"", @"timestamp":@""} error:nil];
}

#pragma mark - Public

- (BOOL)isAuthenticated {
	return self.token != nil;
}

+ (instancetype)unauthenticatedClientWithUser:(MSFUser *)user {
	NSParameterAssert(user != nil);
	MSFClient *client = [[self alloc] initWithServer:user.server];
	client.user = user;
	
	return client;
}

+ (instancetype)authenticatedClientWithUser:(MSFUser *)user token:(NSString *)token session:(NSString *)session {
	NSParameterAssert(user != nil);
	NSParameterAssert(token != nil);
	
	MSFClient *client = [[self alloc] initWithServer:user.server];
	client.user = user;
	client.token = token;
	client.session = session;
	
	return client;
}

+ (RACSignal *)signInAsUser:(MSFUser *)user password:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha {
	NSParameterAssert(user);
	NSParameterAssert(password);
	NSParameterAssert(phone);
	
	RACSignal *(^authorizationSignalWithUser)(MSFUser *) = ^(MSFUser *user) {
		return [RACSignal defer:^RACSignal *{
			MSFClient *client = [self unauthenticatedClientWithUser:user];
			NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
			parameters[@"action"] = @"login";
			parameters[@"phoneNumber"] = phone;
			parameters[@"password"] = password.sha256;
			parameters[@"captcha"] = captcha;
			NSURLRequest *request = [client requestWithMethod:@"POST" path:@"authenticate" parameters:parameters];
			
			return [[client enqueueRequest:request]
				flattenMap:^RACStream *(RACTuple *responseAndResponseObject) {
					RACTupleUnpack(NSHTTPURLResponse *HTTPURLResponse, id responseObject) = responseAndResponseObject;
					if (HTTPURLResponse.statusCode != 200) {
						NSError *error = [NSError errorWithDomain:MSFClientErrorDomain code:0 userInfo:@{}];
						return [RACSignal error:error];
					}
					MSFAuthorization *authorization = [MTLJSONAdapter modelOfClass:MSFAuthorization.class fromJSONDictionary:HTTPURLResponse.allHeaderFields error:nil];
					MSFResponse *response = [[MSFResponse alloc] initWithHTTPURLResponse:HTTPURLResponse parsedResult:authorization];
					MSFUser *user = [MTLJSONAdapter modelOfClass:MSFUser.class fromJSONDictionary:responseObject error:nil];
					[user mergeValueForKey:@keypath(user.server) fromModel:client.user];
					client.user = user;
				
					return [RACSignal combineLatest:@[
						[RACSignal return:client],
						[RACSignal return:response],
					]];
				}];
			}];
		};
	
	return [[[[[authorizationSignalWithUser(user)
		flattenMap:^RACStream *(RACTuple *clientAndResponse) {
			return [RACSignal return:clientAndResponse];
		}]
		catch:^RACSignal *(NSError *error) {
		 return [RACSignal error:error];
		}]
		reduceEach:^id(MSFClient *client, MSFResponse *response){
			MSFAuthorization *authorization = response.parsedResult;
			client.token = authorization.token;
			client.session = authorization.session;
			
			return client;
		}]
		replayLazily] setNameWithFormat:@"`signInAsUser:%@ password:`", user];
}

+ (RACSignal *)signUpAsUser:(MSFUser *)user password:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha {
	RACSignal *(^registeringSignalWithUser)(MSFUser *) = ^(MSFUser *user) {
		MSFClient *client = [self unauthenticatedClientWithUser:user];
		NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
		parameters[@"action"] = @"register";
		parameters[@"phoneNumber"] = phone;
		parameters[@"password"] = password.sha256;
		parameters[@"captcha"] = captcha;
		NSURLRequest *request = [client requestWithMethod:@"POST" path:@"authenticate" parameters:parameters];
		
		return [[client enqueueRequest:request]
			flattenMap:^RACStream *(RACTuple *responseAndResponseObject) {
				RACTupleUnpack(NSHTTPURLResponse *HTTPURLResponse, id responseObject) = responseAndResponseObject;
				if (HTTPURLResponse.statusCode != 200) {
					NSError *error = [NSError errorWithDomain:MSFClientErrorDomain code:0 userInfo:@{}];
					return [RACSignal error:error];
				}
				MSFAuthorization *authorization = [MTLJSONAdapter modelOfClass:MSFAuthorization.class fromJSONDictionary:HTTPURLResponse.allHeaderFields error:nil];
				MSFResponse *response = [[MSFResponse alloc] initWithHTTPURLResponse:HTTPURLResponse parsedResult:authorization];
				MSFUser *user = [MTLJSONAdapter modelOfClass:MSFUser.class fromJSONDictionary:responseObject error:nil];
				[user mergeValueForKey:@keypath(user.server) fromModel:client.user];
				client.user = user;
			 
				return [RACSignal combineLatest:@[
					[RACSignal return:client],
					[RACSignal return:response],
				]];
		}];
	};
	
	return [[[[[registeringSignalWithUser(user)
		flattenMap:^RACStream *(RACTuple *clientAndResponse) {
			return [RACSignal return:clientAndResponse];
		}]
		catch:^RACSignal *(NSError *error) {
		 return [RACSignal error:error];
		}]
		reduceEach:^id(MSFClient *client, MSFResponse *response){
			MSFAuthorization *authorization = response.parsedResult;
			client.token = authorization.token;
			client.session = authorization.session;
		 
			return client;
		}]
		replayLazily] setNameWithFormat:@"`signUpAsUser:%@ password: phone: captcha`", user];
}

- (RACSignal *)signOut {
	self.user = nil;
	self.token = nil;
	self.session = nil;
	NSURLRequest *request = [self requestWithMethod:@"DELETE" path:@"authenticate" parameters:nil];
	@weakify(self)
	return [[[self enqueueRequest:request resultClass:nil]
		flattenMap:^RACStream *(id value) {
			@strongify(self)
			[self clearAuthorizationHeader];
		
			return [RACSignal return:self];
		}]
		replay];
}

- (RACSignal *)realnameAuthentication:(NSString *)name idcard:(NSString *)idcard expire:(NSDate *)date session:(BOOL)session	province:(NSString *)provinceCode city:(NSString *)cityCode bank:(NSString *)bankCode card:(NSString *)card {
	NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
	parameters[@"username"] = name;
	parameters[@"id_card"] = idcard;
	parameters[@"expire"] = !session ? [NSDateFormatter msf_stringFromDate:date] : @"";
	parameters[@"valid_for_lifetime"] = @(session);
	parameters[@"bank_card_number"] = [card stringByReplacingOccurrencesOfString:@" " withString:@""];
	parameters[@"bankCode"] = bankCode;
	parameters[@"bankProvinceCode"] = provinceCode;
	parameters[@"bankCityCode"] = cityCode;
	NSString *path = [NSString stringWithFormat:@"users/%@%@", self.user.objectID, @"/real_name_auth"];;
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:parameters];
	[request setHTTPMethod:@"POST"];
	
	return [[[self enqueueRequest:request resultClass:MSFUser.class]
		flattenMap:^RACStream *(id value) {
			return [self fetchUserInfo];
		}]
		map:^id(id value) {
			self.user = value;
			return self;
		}];
}

#pragma mark - Request

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void(^)(id <AFMultipartFormData> formData))block {
	NSURL *URL = [NSURL URLWithString:path relativeToURL:self.baseURL];
	MSFSignature *signature = [self signatureWithPath:URL.path parameters:parameters];
	NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:method
		URLString:[URL.absoluteString stringByAppendingString:signature.query]
		parameters:nil
		constructingBodyWithBlock:block error:nil];
	request.allHTTPHeaderFields = [request.allHTTPHeaderFields mtl_dictionaryByAddingEntriesFromDictionary:self.defaultHeaders];
	
	return request;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(id)parameters {
	if ([path isEqualToString:@"attachment/saveList"]) {
		NSURL *URL = [NSURL URLWithString:path relativeToURL:self.baseURL];
		MSFSignature *signature = [self signatureWithPath:URL.path parameters:nil];
		NSMutableURLRequest *request = [AFJSONRequestSerializer.serializer requestWithMethod:@"POST"
			URLString:[URL.absoluteString stringByAppendingString:signature.query]
			parameters:parameters
			error:nil];
		request.allHTTPHeaderFields = [request.allHTTPHeaderFields mtl_dictionaryByAddingEntriesFromDictionary:self.defaultHeaders];
		
		return request;
	}
	NSURL *URL = [NSURL URLWithString:path relativeToURL:self.baseURL];
	NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method
		URLString:URL.absoluteString
		parameters:[self signatureArgumentsWithPath:URL.path parameters:parameters]
		error:nil];
	request.allHTTPHeaderFields = [request.allHTTPHeaderFields mtl_dictionaryByAddingEntriesFromDictionary:self.defaultHeaders];
	request.allHTTPHeaderFields = [request.allHTTPHeaderFields mtl_dictionaryByAddingEntriesFromDictionary:@{
		@"Content-Type": @"application/x-www-form-urlencoded; charset=utf-8"
	}];
	
	return request;
}

- (RACSignal *)enqueueRequest:(NSURLRequest *)request resultClass:(Class)resultClass {
	return [[[self
		enqueueRequest:request]
		reduceEach:^(NSHTTPURLResponse *HTTPURLResponse, id responseObject) {
			__block BOOL loggedRemaining = NO;
			
			return [[[self
				parsedResponseOfClass:resultClass fromJSON:responseObject]
				map:^(id parsedResult) {
					MSFResponse *parsedResponse = [[MSFResponse alloc] initWithHTTPURLResponse:HTTPURLResponse parsedResult:parsedResult];
					NSAssert(parsedResponse != nil, @"Could not create MSFResponse with response %@ and parsedResult %@", HTTPURLResponse, parsedResult);
					
					return parsedResponse;
				}]
				doNext:^(MSFResponse *parsedResponse) {
					if (NSProcessInfo.processInfo.environment[MSFClientResponseLoggingEnvironmentKey] == nil) {
						return;
					}
					if (loggedRemaining) {
						return;
					}
				 
					NSLog(@"%@ => %li", HTTPURLResponse.URL, (long)HTTPURLResponse.statusCode);
					loggedRemaining = YES;
				}];
			}]
		concat];
}

- (RACSignal *)enqueueUserRequestWithMethod:(NSString *)method relativePath:(NSString *)relativePath parameters:(NSDictionary *)parameters resultClass:(Class)resultClass {
	NSParameterAssert(method != nil);
	NSAssert([relativePath isEqualToString:@""] || [relativePath hasPrefix:@"/"], @"%@ is not a valid relativePath, it must start with @\"/\", or equal @\"\"", relativePath);
	
	NSString *path;
	if (self.user != nil) {
		path = [NSString stringWithFormat:@"users/%@%@", self.user.objectID, relativePath];
	} else {
		return [RACSignal error:self.class.userRequiredError];
	}
	
	NSMutableURLRequest *request = [self requestWithMethod:method path:path parameters:parameters];
	if (self.authenticated) {
		request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
	}
	
	return [self enqueueRequest:request resultClass:resultClass];
}

#pragma mark - Private

+ (NSString *)deviceWithCoordinate:(CLLocationCoordinate2D)coordinate {
	// Device:平台 +系统版本; + 渠道; + App内部版本号; + 制造商; + 牌子; + 型号; + 编译ID; + 设备ID; + GPS(lat,lng)
	// Android 5.0; msfinance; 10001; Genymotion; generic; Google Nexus 5 - 5.0.0 - API 21 - 1080x1920; 000000000000000;
	NSDictionary *info = [NSBundle mainBundle].infoDictionary;
	NSMutableArray *devices = NSMutableArray.new;
	[devices addObject:[NSString stringWithFormat:@"iOS %@", [UIDevice currentDevice].systemVersion]];
	[devices addObject:@"appstore"];
	[devices addObject:info[@"CFBundleShortVersionString"]];
	[devices addObject:@"Apple"];
	[devices addObject:@"iPhone"];
	[devices addObject:[UIDevice currentDevice].systemName];
	[devices addObject:info[@"CFBundleVersion"]];
	[devices addObject:OpenUDID.value];
	[devices addObject:[NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude]];
	
	return [devices componentsJoinedByString:@";"];
}

+ (NSError *)userRequiredError {
	NSDictionary *userInfo = @{
		NSLocalizedDescriptionKey: NSLocalizedString(@"User identifier Required", @""),
		NSLocalizedFailureReasonErrorKey: NSLocalizedString(@"No User identifier was provided for getting user information.", @""),
	};
	
	return [NSError errorWithDomain:MSFClientErrorDomain code:MSFClientErrorAuthenticationFailed userInfo:userInfo];
}

+ (NSError *)errorFromRequestOperation:(AFHTTPRequestOperation *)operation {
	NSDictionary *userinfo = @{};
	userinfo = [userinfo mtl_dictionaryByAddingEntriesFromDictionary:@{
		MSFClientErrorFieldKey: operation.responseObject[MSFClientErrorFieldKey] ?: @{}
	}];

	userinfo = [userinfo mtl_dictionaryByAddingEntriesFromDictionary:@{
		NSLocalizedFailureReasonErrorKey: operation.responseObject[MSFClientErrorMessageKey] ?: @"",
		MSFClientErrorMessageKey: operation.responseObject[MSFClientErrorMessageKey] ?: @"",
	}];
	
	userinfo = [userinfo mtl_dictionaryByAddingEntriesFromDictionary:@{
		MSFClientErrorMessageCodeKey: operation.responseObject[MSFClientErrorMessageCodeKey] ?: @"",
	}];
	
	return [NSError errorWithDomain:MSFClientErrorDomain code:operation.response.statusCode userInfo:userinfo];
}

- (NSError *)parsingErrorWithFailureReason:(NSString *)localizedFailureReason {
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
	userInfo[NSLocalizedDescriptionKey] = NSLocalizedString(@"Could not parse the service response.", @"");
	
	if (localizedFailureReason != nil) {
		userInfo[NSLocalizedFailureReasonErrorKey] = localizedFailureReason;
	}
	
	return [NSError errorWithDomain:MSFClientErrorDomain code:MSFClientErrorJSONParsingFailed userInfo:userInfo];
}

- (RACSignal *)parsedResponseOfClass:(Class)resultClass fromJSON:(id)responseObject {
	NSParameterAssert(resultClass == nil || [resultClass isSubclassOfClass:MTLModel.class]);
	
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		void(^parseJSONDictionary)(NSDictionary *) = ^(NSDictionary *JSONDictionary) {
			if (resultClass == nil) {
				[subscriber sendNext:JSONDictionary];
				return;
			}
			NSError *error = nil;
			MSFObject *parsedObject = [MTLJSONAdapter modelOfClass:resultClass fromJSONDictionary:JSONDictionary error:&error];
			if (parsedObject == nil) {
				if (![error.domain isEqual:MTLJSONAdapterErrorDomain] || error.code != MTLJSONAdapterErrorNoClassFound) {
					[subscriber sendError:error];
				}
				
				return;
			}
			NSAssert([parsedObject isKindOfClass:MSFObject.class], @"Parsed model object is not an OCTObject: %@", parsedObject);
			
			parsedObject.baseURL = self.baseURL;
			[subscriber sendNext:parsedObject];
		};
		
		if ([responseObject isKindOfClass:NSArray.class]) {
			for (NSDictionary *JSONDictionary in responseObject) {
				if (![JSONDictionary isKindOfClass:NSDictionary.class]) {
					NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Invalid JSON array element: %@", @""), JSONDictionary];
					[subscriber sendError:[self parsingErrorWithFailureReason:failureReason]];
					
					return nil;
				}
				
				parseJSONDictionary(JSONDictionary);
			}
			
			[subscriber sendCompleted];
		} else if ([responseObject isKindOfClass:NSDictionary.class]) {
			parseJSONDictionary(responseObject);
			[subscriber sendCompleted];
		} else if (responseObject == nil) {
			[subscriber sendNext:nil];
			[subscriber sendCompleted];
		} else {
			NSString *failureReason = [NSString stringWithFormat:NSLocalizedString(@"Response wasn't an array or dictionary (%@): %@", @""), [responseObject class], responseObject];
			[subscriber sendError:[self parsingErrorWithFailureReason:failureReason]];
		}
		
		return nil;
	}];
}

- (RACSignal *)enqueueRequest:(NSURLRequest *)request {
	RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
			#if DEBUG
			if (NSProcessInfo.processInfo.environment[MSFClientResponseLoggingEnvironmentKey] != nil) {
				NSLog(@"%@ %@ %@ => %li %@:\n%@", request.HTTPMethod, request.URL, request.allHTTPHeaderFields, (long)operation.response.statusCode, operation.response.allHeaderFields, operation.responseString);
			}
			#elif TEST
				NSLog(@"%@ %@ %@ => %li %@:\n%@", request.HTTPMethod, request.URL, request.allHTTPHeaderFields, (long)operation.response.statusCode, operation.response.allHeaderFields, operation.responseString);
			#endif
			if (operation.response.allHeaderFields[@"msfinance"] && operation.response.allHeaderFields[@"finance"]) {
				MSFAuthorization *authorization = [MTLJSONAdapter modelOfClass:MSFAuthorization.class fromJSONDictionary:operation.response.allHeaderFields error:nil];
				self.token = authorization.token;
				self.session = authorization.session;
			}
			if (!responseObject) {
				if ([request.URL.absoluteString rangeOfString:@"captcha"].length > 0) {
					responseObject = @{@"message": @"短信已下发,请注意查收"};
				}
				if ([request.URL.absoluteString rangeOfString:@"users/forget_password"].length > 0) {
					responseObject = @{@"message": @"更新成功"};
				}
				if ([request.URL.absoluteString rangeOfString:@"update_password"].length > 0) {
					responseObject = @{@"message": @"修改成功"};
				}
				if ([request.URL.absoluteString rangeOfString:@"authenticate"].length > 0 && [request.HTTPMethod isEqualToString:@"DELETE"]) {
					responseObject = @{@"message": @"登录退出"};
				}
			}
			
			if ([responseObject isKindOfClass:NSDictionary.class] && responseObject[@"code"] != 0) {
				[subscriber sendError:[self parsingErrorWithFailureReason:responseObject[@"message"]]];
				return;
			}
			
			if (operation.response.statusCode == MSFClientNotModifiedStatusCode || [responseObject count] == 0) {
				// No change in the data.
				[subscriber sendCompleted];
				return;
			}
			
			[[RACSignal
				 return:RACTuplePack(operation.response, responseObject)]
				 subscribe:subscriber];
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			[self reportFabric:operation error:error];
		
			#if DEBUG
				if (NSProcessInfo.processInfo.environment[MSFClientResponseLoggingEnvironmentKey] != nil) {
					NSLog(@"%@ %@ %@ => FAILED WITH %li %@ \n %@", request.HTTPMethod, request.URL, request.allHTTPHeaderFields, (long)operation.response.statusCode,operation.response.allHeaderFields,operation.responseString);
				}
			#elif TEST
				NSLog(@"%@ %@ %@ => FAILED WITH %li %@ \n %@", request.HTTPMethod, request.URL, request.allHTTPHeaderFields, (long)operation.response.statusCode,operation.response.allHeaderFields,operation.responseString);
			#endif
			
			if (operation.response.allHeaderFields[@"msfinance"] && operation.response.allHeaderFields[@"finance"]) {
				MSFAuthorization *authorization = [MTLJSONAdapter modelOfClass:MSFAuthorization.class fromJSONDictionary:operation.response.allHeaderFields error:nil];
				self.token = authorization.token;
				self.session = authorization.session;
			}
			
			if (operation.response.statusCode == 403) {
				NSString *timestamp = operation.response.allHeaderFields[@"timestamp"];
				MSFCipher *cipher = [[MSFCipher alloc] initWithSession:timestamp.longLongValue];
				[MSFClient setCipher:cipher];
			}
			
			if (operation.response.statusCode == MSFClientErrorAuthenticationFailed) {
				[MSFUtils setHttpClient:nil];
				[[NSNotificationCenter defaultCenter] postNotificationName:MSFClientErrorAuthenticationFailedNotification object:[self.class errorFromRequestOperation:operation]];
			}
			
			[subscriber sendError:[self.class errorFromRequestOperation:operation]];
		}];
		
		[self enqueueHTTPRequestOperation:operation];
		
		return [RACDisposable disposableWithBlock:^{
			[operation cancel];
		}];
	}];
	
	return [[signal replayLazily] setNameWithFormat:@"`enqueueRequest: %@`", request];
}

- (void)reportFabric:(AFHTTPRequestOperation *)operation error:(NSError *)error {
	NSString *responseString = operation.responseString ?: @"";
	NSString *errorInfo = error.localizedDescription ?: @"";
	[Answers logCustomEventWithName:@"RequestError"
								 customAttributes:@{@"responseString" : responseString,
																		@"errorInfo" : errorInfo}];
}

- (void)enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)operation {
	[self.operationQueue addOperation:operation];
}

#pragma mark - defaultHeaders

- (NSString *)defaultValueForHeader:(NSString *)header {
	return [self.defaultHeaders valueForKey:header];
}

- (void)setDefaultHeader:(NSString *)header value:(NSString *)value {
	[self.defaultHeaders setValue:value forKey:header];
}

- (void)setAuthorizationHeaderWithToken:(NSString *)token {
		[self setDefaultHeader:@"finance" value:token];
}

- (void)setAuthorizationHeaderWithSession:(NSString *)session {
	[self setDefaultHeader:@"msfinance" value:session];
}

- (void)clearAuthorizationHeader {
	[self.defaultHeaders removeObjectForKey:@"msfinance"];
	[self.defaultHeaders removeObjectForKey:@"finance"];
}

@end
