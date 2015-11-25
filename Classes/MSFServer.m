//
// MSFServer.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFServer.h"
#import "MSFServer+Private.h"

#if DEBUG

//NSString *const MSFServerDotComAPIEndpoint = @"http://api4.msxf.test";
//NSString *const MSFServerDotComBaseWebURL = @"http://api4.msxf.test";

NSString *const MSFServerDotComAPIEndpoint = @"http://10.16.18.36:8080";
NSString *const MSFServerDotComBaseWebURL = @"http://10.16.18.36:8080";

#elif TEST

static NSString *URLString(void) {
	NSString *url = [NSUserDefaults.standardUserDefaults stringForKey:@"test_url"];
	return url ?: @"http://api4.msxf.test";
}

#else

NSString *const MSFServerDotComAPIEndpoint = @"https://mapi.msxf.com";
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
#if TEST
		return [[NSURL URLWithString:URLString()] URLByAppendingPathComponent:MSFServerAPIEndpointPathComponent isDirectory:YES];
#else
	if (self.baseURL == nil) {
		NSString *endpoint = NSProcessInfo.processInfo.environment[@"API_ENDPOINT"];
		if (endpoint != nil) return [NSURL URLWithString:endpoint];
		return [[NSURL URLWithString:MSFServerDotComAPIEndpoint] URLByAppendingPathComponent:MSFServerAPIEndpointPathComponent isDirectory:YES];
	} else {
		return [self.baseURL URLByAppendingPathComponent:MSFServerAPIEndpointPathComponent isDirectory:YES];
	}
#endif
}

- (NSURL *)baseWebURL {
#if TEST
	return [[NSURL URLWithString:URLString()] URLByAppendingPathComponent:MSFServerAPIBaseWebPathComponent];
#else
	NSString *endpoint = NSProcessInfo.processInfo.environment[@"BASE_WEBURL"];
	if (endpoint.length > 0) return [NSURL URLWithString:endpoint];
	return [[NSURL URLWithString:MSFServerDotComBaseWebURL] URLByAppendingPathComponent:MSFServerAPIBaseWebPathComponent];
#endif
}

@end
