//
// MSFServer.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFServer.h"
#import "MSFServer+Private.h"

#if DEBUG

NSString *const MSFServerDotComAPIEndpoint = @"https://api.msfinance.cn";
NSString *const MSFServerAPIEndpointPathComponent = @"msfinanceapi/v1";
NSString *const MSFServerDotComBaseWebURL = @"https://msfinance.cn";
NSString *const MSFServerAPIBaseWebPathComponent = @"msfinanceweb";

#else

NSString *const MSFServerDotComAPIEndpoint = @"https://api.msfinance.cn";
NSString *const MSFServerAPIEndpointPathComponent = @"msfinanceapi/v1";
NSString *const MSFServerDotComBaseWebURL = @"https://msfinance.cn";
NSString *const MSFServerAPIBaseWebPathComponent = @"msfinanceweb";

#endif

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
		
		return [NSURL URLWithString:MSFServerDotComAPIEndpoint];
	} else {
		return [self.baseURL URLByAppendingPathComponent:MSFServerAPIEndpointPathComponent isDirectory:YES];
	}
}

- (NSURL *)baseWebURL {
	if (self.baseURL == nil) {
		return [NSURL URLWithString:MSFServerDotComBaseWebURL];
	} else {
		return self.baseURL;
	}
}

@end
