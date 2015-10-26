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
#import <Mantle/EXTScope.h>
#import <NSString-Hashes/NSString+Hashes.h>
#import "MSFSignature.h"
#import "RCLocationManager.h"
#import <Crashlytics/Crashlytics.h>
#import "MSFDeviceGet.h"
#import "UIDevice-Hardware.h"

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
const NSInteger MSFClientResponseWithoutContent = 204;

NSString *const MSFClientErrorFieldKey = @"fields";
NSString *const MSFClientErrorMessageCodeKey = @"code";
NSString *const MSFClientErrorMessageKey = @"message";

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

static NSDictionary *messages;

@interface MSFClient ()

@property (nonatomic, strong) NSMutableDictionary *defaultHeaders;
@property (nonatomic, strong, readwrite) MSFUser *user;
@property (nonatomic, copy, readwrite) NSString *token;
@property (nonatomic, strong) NSString *reachabilityStatus;

@end

@implementation MSFClient

#pragma mark - Lifecycle

- (instancetype)initWithServer:(MSFServer *)server {
	NSParameterAssert(server != nil);
	if (!(self = [super initWithBaseURL:server.APIEndpoint])) {
		return nil;
	}
	self.reachabilityStatus = @"9";
	self.defaultHeaders = NSMutableDictionary.dictionary;
	[self setDefaultHeader:@"deviceInfo" value:[self.class deviceInfoWithCoordinate:CLLocationCoordinate2DMake(0, 0) reachabilityStatus:self.reachabilityStatus]];
	
	self.requestSerializer.timeoutInterval = 60;
	self.securityPolicy.allowInvalidCertificates = YES;
	
	cipher = [[MSFCipher alloc] initWithTimestamp:(long long)[NSDate.date timeIntervalSince1970] * 1000];
	
	if (isRunningTests()) {
		return self;
	}
	
	CLAuthorizationStatus const status = [CLLocationManager authorizationStatus];
	if (status > 1) {
		[[RCLocationManager sharedManager] setUserDistanceFilter:kCLLocationAccuracyKilometer];
		[[RCLocationManager sharedManager] setUserDesiredAccuracy:kCLLocationAccuracyKilometer];
		[[RCLocationManager sharedManager] startUpdatingLocationWithBlock:^(CLLocationManager *manager, CLLocation *newLocation, CLLocation *oldLocation) {
			[self setDefaultHeader:@"deviceInfo" value:[self.class deviceInfoWithCoordinate:newLocation.coordinate reachabilityStatus:self.reachabilityStatus]];
			[[RCLocationManager sharedManager] stopUpdatingLocation];
		} errorBlock:^(CLLocationManager *manager, NSError *error) {}];
	}
	
	@weakify(self)
	[self.reachabilityManager startMonitoring];
	[self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
		NSString *network;
		switch (status) {
			case AFNetworkReachabilityStatusUnknown: {
				network = @"9";
				break;
			}
			case AFNetworkReachabilityStatusNotReachable: {
				network = @"0";
				break;
			}
			case AFNetworkReachabilityStatusReachableViaWWAN: {
				network = @"4";
				break;
			}
			case AFNetworkReachabilityStatusReachableViaWiFi: {
				network = @"1";
				break;
			}
			default: {
				network = @"9";
				break;
			}
		}
		@strongify(self)
		self.reachabilityStatus = network;
		CLLocationCoordinate2D coordinate = [RCLocationManager sharedManager].location.coordinate;
		[self setDefaultHeader:@"deviceInfo" value:[self.class deviceInfoWithCoordinate:coordinate reachabilityStatus:self.reachabilityStatus]];
	}];
	
	NSURL *URL = [[NSBundle bundleForClass:self.class] URLForResource:@"code-message" withExtension:@"json"];
	NSData *data = [NSData dataWithContentsOfURL:URL];
	messages = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
	
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

+ (instancetype)authenticatedClientWithUser:(MSFUser *)user token:(NSString *)token {
	NSParameterAssert(user != nil);
	NSParameterAssert(token != nil);
	
	MSFClient *client = [[self alloc] initWithServer:user.server];
	client.user = user;
	client.token = token;
	
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
			parameters[@"logType"] = @"1";
			parameters[@"mobile"] = phone;
			parameters[@"password"] = password.sha256;
			parameters[@"imei"] = MSFDeviceGet.imei;
			if (captcha.length > 0) parameters[@"smsCode"] = captcha ?: @"";
			NSURLRequest *request = [client requestWithMethod:@"POST" path:@"user/login" parameters:parameters];
			
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
			
			return client;
		}]
		replayLazily] setNameWithFormat:@"`signInAsUser:%@ password:`", user];
}

+ (RACSignal *)signInAsUser:(MSFUser *)user username:(NSString *)username password:(NSString *)password citizenID:(NSString *)idcard {
	NSParameterAssert(user);
	NSParameterAssert(password);
	NSParameterAssert(idcard);
	NSParameterAssert(username);
	
	RACSignal *(^authorizationSignalWithUser)(MSFUser *) = ^(MSFUser *user) {
		return [RACSignal defer:^RACSignal *{
			MSFClient *client = [self unauthenticatedClientWithUser:user];
			NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
			parameters[@"logType"] = @"2";
			parameters[@"ident"] = idcard;
			parameters[@"password"] = password.sha256;
			parameters[@"imei"] = MSFDeviceGet.imei;
			parameters[@"name"] = username;
			NSURLRequest *request = [client requestWithMethod:@"POST" path:@"user/login" parameters:parameters];
			
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
		 
			return client;
		}]
		replayLazily] setNameWithFormat:@"`signUpAsUser:%@ password: phone: captcha`", user];
}

+ (RACSignal *)signUpAsUser:(MSFUser *)user password:(NSString *)password phone:(NSString *)phone captcha:(NSString *)captcha realname:(NSString *)realname citizenID:(NSString *)citizenID citizenIDExpiredDate:(NSDate *)expiredDate {
	RACSignal *(^registeringSignalWithUser)(MSFUser *) = ^(MSFUser *user) {
		MSFClient *client = [self unauthenticatedClientWithUser:user];
		NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
		parameters[@"mobile"] = phone;
		parameters[@"password"] = password.sha256;
		parameters[@"smsCode"] = captcha;
		parameters[@"name"] = realname;
		parameters[@"ident"] = citizenID;
		parameters[@"identLastDate"] = [NSDateFormatter msf_stringFromDate:expiredDate];
		NSURLRequest *request = [client requestWithMethod:@"POST" path:@"user/regist" parameters:parameters];
		
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
		 
			return client;
		}]
		replayLazily] setNameWithFormat:@"`signUpAsUser:%@ password: phone: captcha`", user];
}

- (RACSignal *)signOut {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"user/logout" parameters:@{
		@"uniqueId": self.user.uniqueId
	}];
	
	@weakify(self)
	return [[[[self enqueueRequest:request resultClass:nil]
		catch:^RACSignal *(NSError *error) {
			@strongify(self)
			[self clearAuthorizationHeader];
			self.token = nil;
			self.user = nil;
			return [RACSignal error:error];
		}]
		doNext:^(id x) {
			@strongify(self)
			[self clearAuthorizationHeader];
			self.token = nil;
			self.user = nil;
		}]
		replay];
}

#pragma mark - Request

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void(^)(id <AFMultipartFormData> formData))block {
	NSURL *URL = [NSURL URLWithString:path relativeToURL:self.baseURL];
	NSMutableURLRequest *request = [self.requestSerializer multipartFormRequestWithMethod:method
		URLString:URL.absoluteString
		parameters:[self signatureArgumentsWithPath:URL.path parameters:parameters]
		constructingBodyWithBlock:block error:nil];
	request.allHTTPHeaderFields = [request.allHTTPHeaderFields mtl_dictionaryByAddingEntriesFromDictionary:self.defaultHeaders];
	
	return request;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(id)parameters {
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

+ (NSString *)deviceInfoWithCoordinate:(CLLocationCoordinate2D)coordinate reachabilityStatus:(NSString *)status {
	NSDictionary *info = [NSBundle mainBundle].infoDictionary;
	NSMutableArray *devices = NSMutableArray.new;
	[devices addObject:@"IOS"];
	[devices addObject:[UIDevice currentDevice].systemVersion];
	[devices addObject:@"appstore"];
	[devices addObject:[info[@"CFBundleVersion"] stringByReplacingOccurrencesOfString:@"." withString:@""]];
	[devices addObject:@"Apple"];
	[devices addObject:@"iPhone"];
	[devices addObject:[UIDevice currentDevice].modelIdentifier];
	[devices addObject:info[@"CFBundleVersion"]];
	[devices addObject:OpenUDID.value];
	[devices addObject:[NSString stringWithFormat:@"%f,%f", coordinate.latitude, coordinate.longitude]];
	[devices addObject:status];
	[devices addObject:@""];
	
	return [[devices componentsJoinedByString:@"; "] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
	
	// Fields error
	userinfo = [userinfo mtl_dictionaryByAddingEntriesFromDictionary:@{
		MSFClientErrorFieldKey: operation.responseObject[MSFClientErrorFieldKey] ?: @{}
	}];

	NSString *code = operation.responseObject[MSFClientErrorMessageCodeKey];
	NSString *message = messages[MSFClientErrorMessageCodeKey] ?: operation.responseObject[MSFClientErrorMessageKey];
	
	// Message
	userinfo = [userinfo mtl_dictionaryByAddingEntriesFromDictionary:@{
		NSLocalizedFailureReasonErrorKey: message ?: @"",
		MSFClientErrorMessageKey: message ?: @"",
	}];
	
	// Code
	userinfo = [userinfo mtl_dictionaryByAddingEntriesFromDictionary:@{
		MSFClientErrorMessageCodeKey: code ?: @"",
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
					NSLog(@"%@ %@ %@ %@ => %li %@:\n%@", request.HTTPMethod, request.URL, request.allHTTPHeaderFields, [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], (long)operation.response.statusCode, operation.response.allHeaderFields, operation.responseString);
				}
			#elif TEST
				NSLog(@"%@ %@ %@ %@ => %li %@:\n%@", request.HTTPMethod, request.URL, request.allHTTPHeaderFields, [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], (long)operation.response.statusCode, operation.response.allHeaderFields, operation.responseString);
			#endif
			
			[[RACSignal return:RACTuplePack(operation.response, responseObject)] subscribe:subscriber];
			
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			#if DEBUG
				if (NSProcessInfo.processInfo.environment[MSFClientResponseLoggingEnvironmentKey] != nil) {
					NSLog(@"%@ %@ %@ %@ => FAILED WITH %li %@ \n %@", request.HTTPMethod, request.URL, request.allHTTPHeaderFields, [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], (long)operation.response.statusCode,operation.response.allHeaderFields,operation.responseString);
				}
			#elif TEST
				NSLog(@"%@ %@ %@ %@ => FAILED WITH %li %@ \n %@", request.HTTPMethod, request.URL, request.allHTTPHeaderFields, [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], (long)operation.response.statusCode,operation.response.allHeaderFields,operation.responseString);
			#endif
			
			if (operation.response.statusCode == MSFClientErrorAuthenticationFailed) {
				[[NSNotificationCenter defaultCenter] postNotificationName:MSFClientErrorAuthenticationFailedNotification object:[self.class errorFromRequestOperation:operation]];
			}
			
			[self reportFabric:operation error:error];
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
	[Answers logCustomEventWithName:@"RequestError" customAttributes:@{
		@"responseString": responseString,
		@"errorInfo" : errorInfo
	}];
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
	[self setDefaultHeader:@"token" value:token];
}

- (void)clearAuthorizationHeader {
	[self.defaultHeaders removeObjectForKey:@"token"];
}

@end
