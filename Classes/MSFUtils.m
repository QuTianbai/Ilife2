//
// MSFUtils.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFUtils.h"
#import <AFNetworking/AFNetworking.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFClient.h"
#import "MSFServer.h"
#import "MSFUser.h"
#import "MSFClient+Cipher.h"
#import "MSFResponse.h"
#import "MSFCipher.h"
#import "MSFAuthorization.h"
#import "MSFAgreement.h"
#import "MSFAgreementViewModel.h"
#import "MSFUtilsViewController.h"
#import "MSFIntergrant.h"

NSString *const MSFAuthorizationDidErrorNotification = @"MSFAuthorizationDidErrorNotification";
NSString *const MSFAuthorizationDidLoseConnectNotification = @"MSFAuthorizationDidLoseConnectNotification";

static MSFClient *client;
static MSFServer *server;
static MSFIntergrant *upgrade;

@implementation MSFUtils

+ (void)initialize {
	server = [MSFServer dotComServer];
#if !DISTRIBUTION && !UAT
	server = MSFUtils.baseURLString.length > 0 ? [MSFServer serverWithBaseURL:[NSURL URLWithString:MSFUtils.baseURLString]] : [MSFServer dotComServer];
#endif
}

+ (RACSignal *)setupSignal {
	[self setHttpClient:nil];
	[[[NSNotificationCenter defaultCenter] rac_addObserverForName:MSFUtilsURLDidUpdateNotification object:nil]
		subscribeNext:^(NSNotification *notificaiton) {
			NSURL *URL = [NSURL URLWithString:notificaiton.object];
			server = [MSFServer serverWithBaseURL:URL];
			[self setHttpClient:nil];
			[[self.httpClient fetchServerInterval] subscribeNext:^(MSFResponse *response) {
				MSFCipher *cipher = [[MSFCipher alloc] initWithSession:[response.parsedResult[@"time"] longLongValue]];
				[MSFClient setCipher:cipher];
			}];
		}];
	
	return [[[self.httpClient fetchServerInterval]
		zipWith:[self.class fetchUpgrade]]
		doNext:^(RACTuple *responseAndUpgrade) {
			RACTupleUnpack(MSFResponse *response, MSFIntergrant *aUpgrade) = responseAndUpgrade;
			MSFCipher *cipher = [[MSFCipher alloc] initWithSession:[response.parsedResult[@"time"] longLongValue]];
			[MSFClient setCipher:cipher];
			upgrade = aUpgrade;
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

+ (void)setPhone:(NSString *)_phone {
	[[NSUserDefaults standardUserDefaults] setObject:_phone?:@"" forKey:@"user-phone"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)phone {
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"user-phone"];
}

+ (void)setBaseURLString:(NSString *)url {
	[[NSUserDefaults standardUserDefaults] setObject:url?:@"" forKey:@"user-base-url"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)baseURLString {
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"user-base-url"];
}

+ (RACSignal *)fetchUpgrade {
	// http://10.16.18.36:8081/msfinanceapi/V1/register
	NSURLRequest *request = [client requestWithMethod:@"GET" path:@"register" parameters:nil];
	return [[[client enqueueRequest:request resultClass:nil]
		catch:^RACSignal *(NSError *error) {
			return [RACSignal return:[[MSFIntergrant alloc] initWithUpgrade:NO HTMLURL:[NSURL URLWithString:@"http://baidu.com"]]];
		}]
		map:^id(MSFResponse *response) {
			if ([response isKindOfClass:MSFResponse.class])
				return [MTLJSONAdapter modelOfClass:[MSFIntergrant class] fromJSONDictionary:response.parsedResult error:nil];
			return response;
		}];
}

+ (MSFIntergrant *)upgrade {
	return upgrade;
}

@end
