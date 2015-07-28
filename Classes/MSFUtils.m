//
// MSFUtils.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUtils.h"
#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFClient.h"
#import "MSFServer.h"
#import "MSFUser.h"
#import "MSFClient+Cipher.h"
#import "MSFResponse.h"
#import "MSFCipher.h"
#import "MSFAuthorization.h"
#import "MSFAgreement.h"
#import "MSFAgreementViewModel.h"

static NSString *const MSFAutologinbuggingEnvironmentKey = @"LOGIN_AUTO_DEBUG";

NSString *const MSFAuthorizationDidUpdateNotification = @"MSFAuthorizationDidUpdateNotification";
NSString *const MSFAuthorizationDidErrorNotification = @"MSFAuthorizationDidErrorNotification";
NSString *const MSFAuthorizationDidLoseConnectNotification = @"MSFAuthorizationDidLoseConnectNotification";
NSString *const MSFAuthorizationDidReGetTimeServer = @"MSFAuthorizationDidReGetTimeServer";

static MSFClient *client;
static MSFServer *server;
static NSString *cachePath;

static BOOL isRunningTests(void) __attribute__((const));

static BOOL isRunningTests(void) {
	NSDictionary *environment = [[NSProcessInfo processInfo] environment];
	NSString *injectBundle = environment[@"XCInjectBundle"];
	BOOL isTestsRunning = [[injectBundle pathExtension] isEqualToString:@"xctest"] ||
	[[injectBundle pathExtension] isEqualToString:@"octest"];
	
	return isTestsRunning;
}

@implementation MSFUtils

+ (RACSignal *)setupSignal {
	server = [MSFServer serverWithBaseURL:[NSURL URLWithString:@"https://192.168.2.51:8443"]];
	MSFClient *client = self.unArchiveClient;
	[self setHttpClient:client];
	
	return [[self.httpClient fetchServerInterval] doNext:^(MSFResponse *resposne) {
		MSFCipher *cipher = [[MSFCipher alloc] initWithSession:[resposne.parsedResult[@"time"] longLongValue]];
		[MSFClient setCipher:cipher];
	}] ;
}

+ (MSFClient *)httpClient {
	return client;
}

+ (MSFServer *)server {
	return server;
}

+ (void)setHttpClient:(MSFClient *)httpClient {
	if (httpClient) {
		client = httpClient;
		[[NSNotificationCenter defaultCenter] postNotificationName:MSFAuthorizationDidUpdateNotification object:client];
		[self archiveClient:client];
		return;
	}
	client = [[MSFClient alloc] initWithServer:server];
	[[NSNotificationCenter defaultCenter] postNotificationName:MSFAuthorizationDidUpdateNotification object:client];
	[self cleanupArchive];
}

+ (void)archiveClient:(MSFClient *)client {
	if (!NSProcessInfo.processInfo.environment[MSFAutologinbuggingEnvironmentKey] && !isRunningTests()) {
		return;
	}
	NSString *dir = isRunningTests() ? NSTemporaryDirectory() : [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
	NSString *userPath = [dir stringByAppendingPathComponent:@"user.plist"];
	NSString *authorizationPath = [dir stringByAppendingPathComponent:@"authorization.plist"];
	[NSKeyedArchiver archiveRootObject:client.user toFile:userPath];
	NSDictionary *representation = @{@"finance": client.token, @"msfinance": client.session};
	MSFAuthorization *authorization = [MTLJSONAdapter modelOfClass:MSFAuthorization.class fromJSONDictionary:representation error:nil];
	[NSKeyedArchiver archiveRootObject:authorization toFile:authorizationPath];
}

+ (MSFClient *)unArchiveClient {
	if (!NSProcessInfo.processInfo.environment[MSFAutologinbuggingEnvironmentKey] && !isRunningTests()) {
		return nil;
	}
	NSString *dir = isRunningTests() ? NSTemporaryDirectory() : [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
	NSString *userPath = [dir stringByAppendingPathComponent:@"user.plist"];
	NSString *authorizationPath = [dir stringByAppendingPathComponent:@"authorization.plist"];
	MSFUser *user = [NSKeyedUnarchiver unarchiveObjectWithFile:userPath];
	MSFAuthorization *authorization = [NSKeyedUnarchiver unarchiveObjectWithFile:authorizationPath];
	if (!user || !authorization) {
		return nil;
	}
	
	return [MSFClient authenticatedClientWithUser:user token:authorization.token session:authorization.session];
}

+ (void)cleanupArchive {
	NSString *dir = isRunningTests() ? NSTemporaryDirectory() : [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
	NSString *userPath = [dir stringByAppendingPathComponent:@"user.plist"];
	NSString *authorizationPath = [dir stringByAppendingPathComponent:@"authorization.plist"];
	[[NSFileManager defaultManager] removeItemAtPath:userPath error:nil];
	[[NSFileManager defaultManager] removeItemAtPath:authorizationPath error:nil];
	client = [[MSFClient alloc] initWithServer:server];
}

+ (MSFAgreementViewModel *)agreementViewModel {
	static dispatch_once_t onceToken;
	static MSFAgreementViewModel *viewModel;
	dispatch_once(&onceToken, ^{
		MSFServer *server = [MSFServer serverWithBaseURL:[NSURL URLWithString:@"http://www.msxf.com"]];
		MSFAgreement *agreement = [[MSFAgreement alloc] initWithServer:server];
		viewModel = [[MSFAgreementViewModel alloc] initWithModel:agreement];
	});
	
	return viewModel;
}

+ (void)setPhone:(NSString *)_phone {
	[[NSUserDefaults standardUserDefaults] setObject:_phone?:@"" forKey:@"user-phone"];
}

+ (NSString *)phone {
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"user-phone"];
}

@end
