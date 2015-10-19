//
// MSFServer.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFServer.h"
#import "MSFServer+Private.h"

#if DEBUG

NSString *const MSFServerDotComAPIEndpoint = @"https://i.msxf.test";
NSString *const MSFServerDotComBaseWebURL = @"http://192.168.2.51:8088/msfinanceweb";

#elif UAT

NSString *const MSFServerDotComAPIEndpoint = @"https://i.msxf.uat";
NSString *const MSFServerDotComBaseWebURL = @"http://www.msxf.com";

#elif DISTRIBUTION

NSString *const MSFServerDotComAPIEndpoint = @"https://i.msxf.com";
NSString *const MSFServerDotComBaseWebURL = @"http://www.msxf.com";

#else

NSString *const MSFServerDotComAPIEndpoint = @"https://i.msxf.tp";
NSString *const MSFServerDotComBaseWebURL = @"https://i.msxf.tp";

#endif

NSString *const MSFServerAPIEndpointPathComponent = @"msfinanceapi/v1";
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
