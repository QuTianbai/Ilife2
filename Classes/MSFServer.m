//
// MSFServer.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFServer.h"
#import "MSFServer+Private.h"

#if DEBUG

NSString *const MSFServerDotComAPIEndpoint = @"http://api2.msxf.lotest";
NSString *const MSFServerDotComBaseWebURL = @"http://api2.msxf.lotest";

#elif UAT

NSString *const MSFServerDotComAPIEndpoint = @"https://i.msxf.uat";
NSString *const MSFServerDotComBaseWebURL = @"http://www.msxf.com";

#elif TEST

static NSString *URLString(void) {
	NSString *url = [NSUserDefaults.standardUserDefaults stringForKey:@"test_url"];
	return url ?: @"http://api3.msxf.test";
}

NSString *const MSFServerDotComAPIEndpoint = @"http://api3.msxf.test";
NSString *const MSFServerDotComBaseWebURL = @"http://api3.msxf.test";


#elif TP

NSString *const MSFServerDotComAPIEndpoint = @"https://i.msxf.tp";
NSString *const MSFServerDotComBaseWebURL = @"https://i.msxf.tp";

#else

NSString *const MSFServerDotComAPIEndpoint = @"https://i.msxf.com";
NSString *const MSFServerDotComBaseWebURL = @"http://www.msxf.com";

#endif

NSString *const MSFServerAPIEndpointPathComponent = @"api/app/V1";
NSString *const MSFServerAPIBaseWebPathComponent = @"api/app/V1";

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
		
#if TEST
		return [[NSURL URLWithString:URLString()] URLByAppendingPathComponent:MSFServerAPIEndpointPathComponent isDirectory:YES];
#endif
		return [[NSURL URLWithString:MSFServerDotComAPIEndpoint] URLByAppendingPathComponent:MSFServerAPIEndpointPathComponent isDirectory:YES];
	} else {
		return [self.baseURL URLByAppendingPathComponent:MSFServerAPIEndpointPathComponent isDirectory:YES];
	}
}

- (NSURL *)baseWebURL {
	NSString *endpoint = NSProcessInfo.processInfo.environment[@"BASE_WEBURL"];
	if (endpoint.length > 0) return [NSURL URLWithString:endpoint];
	return [[NSURL URLWithString:MSFServerDotComBaseWebURL] URLByAppendingPathComponent:MSFServerAPIBaseWebPathComponent];
}

@end
