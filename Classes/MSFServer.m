//
// MSFServer.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFServer.h"
#import "MSFServer+Private.h"

#if DEBUG
//
//NSString *const MSFServerDotComAPIEndpoint = @"http://10.16.18.123:8080";
//NSString *const MSFServerDotComBaseWebURL = @"http://10.16.18.123:8080/msfinanceweb";//66
NSString *const MSFServerDotComAPIEndpoint = @"http://10.16.18.36:8080";
NSString *const MSFServerDotComBaseWebURL = @"http://10.16.18.36:8080/msfinanceweb";
//NSString *const MSFServerDotComAPIEndpoint = @"http://10.16.18.36:8080";
//NSString *const MSFServerDotComBaseWebURL = @"http://10.16.18.36:8080/msfinanceweb";

#elif UAT

NSString *const MSFServerDotComAPIEndpoint = @"https://i.msxf.uat";
NSString *const MSFServerDotComBaseWebURL = @"http://www.msxf.com";

#elif TEST

NSString *const MSFServerDotComAPIEndpoint = @"https://192.168.2.61";
NSString *const MSFServerDotComBaseWebURL = @"https://192.168.2.61";

#elif TP

NSString *const MSFServerDotComAPIEndpoint = @"https://i.msxf.tp";
NSString *const MSFServerDotComBaseWebURL = @"https://i.msxf.tp";

#else

NSString *const MSFServerDotComAPIEndpoint = @"https://i.msxf.com";
NSString *const MSFServerDotComBaseWebURL = @"http://www.msxf.com";

#endif

NSString *const MSFServerAPIEndpointPathComponent = @"api/app/V1";
NSString *const MSFServerAPIBaseWebPathComponent = @"msfinanceweb";

@implementation MSFServer

#pragma mark Lifecycle

+ (instancetype)dotComServer {
	static MSFServer *dotComServer = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dotComServer = [[self alloc] initWithBaseURL:nil];
	});
	
	return dotComServer;
}

+ (instancetype)serverWithBaseURL:(NSURL *)baseURL {
	if (baseURL == nil) {
	 return self.dotComServer;
	}
	
	return [[MSFServer alloc] initWithBaseURL:baseURL];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL {
	if (!(self = [super init])) {
		return nil;
	}
	
	_baseURL = baseURL;
	
	return self;
}

#pragma mark Properties

- (NSURL *)APIEndpoint {
	if (self.baseURL == nil) {
		// This environment variable can be used to debug API requests by
		// redirecting them to a different URL.
		NSString *endpoint = NSProcessInfo.processInfo.environment[@"API_ENDPOINT"];
		if (endpoint != nil) {
		 return [NSURL URLWithString:endpoint];
		}
		
		return [[NSURL URLWithString:MSFServerDotComAPIEndpoint] URLByAppendingPathComponent:MSFServerAPIEndpointPathComponent isDirectory:YES];
	} else {
		return [self.baseURL URLByAppendingPathComponent:MSFServerAPIEndpointPathComponent isDirectory:YES];
	}
}

- (NSURL *)baseWebURL {
	NSString *endpoint = NSProcessInfo.processInfo.environment[@"BASE_WEBURL"];
	if (endpoint.length > 0) return [NSURL URLWithString:endpoint];
	return [NSURL URLWithString:MSFServerDotComBaseWebURL];
}

@end
