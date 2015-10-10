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
#import "MSFClient+ReleaseNote.h"
#import "MSFReleaseNote.h"

static MSFClient *client;
static MSFServer *server;

@implementation MSFUtils

#pragma mark - Lifecycle

+ (void)initialize {
	server = MSFServer.dotComServer;
}

#pragma mark - Custom Accessors

+ (RACSignal *)setupSignal {
	// 设置默认时间戳
	MSFCipher *cipher = [[MSFCipher alloc] initWithTimestamp:(long long)[[NSDate date] timeIntervalSince1970] * 1000];
	[MSFClient setCipher:cipher];
	
	client = [[MSFClient alloc] initWithServer:server];
	return [[self.httpClient fetchReleaseNote] doNext:^(MSFReleaseNote *releasenote) {
		MSFCipher *cipher = [[MSFCipher alloc] initWithTimestamp:[releasenote.timestamp longLongValue]];
		[MSFClient setCipher:cipher];
	}];
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
		return;
	}
	client = [[MSFClient alloc] initWithServer:server];
}

+ (MSFAgreementViewModel *)agreementViewModel {
	MSFAgreement *agreement = [[MSFAgreement alloc] initWithServer:MSFServer.dotComServer];
	MSFAgreementViewModel *viewModel = [[MSFAgreementViewModel alloc] initWithModel:agreement];
	
	return viewModel;
}

#pragma mark - Persistent values

+ (void)setPhone:(NSString *)_phone {
	[[NSUserDefaults standardUserDefaults] setObject:_phone?:@"" forKey:@"user-phone"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)phone {
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"user-phone"];
}

+ (void)setRegisterPhone:(NSString *)phone {
	[[NSUserDefaults standardUserDefaults] setObject:phone?:@"" forKey:@"user-registerPhone"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)registerPhone {
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"user-registerPhone"];
}

+ (void)setBaseURLString:(NSString *)url {
	[[NSUserDefaults standardUserDefaults] setObject:url?:@"" forKey:@"user-base-url"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)baseURLString {
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"user-base-url"];
}

+ (void)setUniqueId:(NSString *)uniqueId {
	[[NSUserDefaults standardUserDefaults] setObject:uniqueId?:@"" forKey:@"uniqueId"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)uniqueId {
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"uniqueId"];
}

+ (void)setisTradePassword:(NSString *)isSetTradePassword {
	[[NSUserDefaults standardUserDefaults] setObject:isSetTradePassword?:@"" forKey:@"isSetTradePassword"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)isSetTradePassword {
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"isSetTradePassword"];
}

+ (void)setCircuteCash:(NSString *)isCircuteCash {
	[[NSUserDefaults standardUserDefaults] setObject:isCircuteCash?:@"" forKey:@"isCircuteCash"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)isCircuteCash {
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"isCircuteCash"];
}

+ (void)setProductCode:(NSString *)procd {
	[[NSUserDefaults standardUserDefaults] setObject:procd?:@"" forKey:@"productCode"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)productCode {
	//return @"2001";
	NSLog(@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"productCode"]);
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"productCode"];
}

+ (NSString *)complateCustInfo {
	return MSFUtils.httpClient.user.complateCustInfo;
}

@end
