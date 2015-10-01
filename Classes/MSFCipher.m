//
// Cipher.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFCipher.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import "MSFResponse.h"
#import "MSFSignature.h"
#import "MSFClient+Cipher.h"
#import "NSURL+QueryDictionary.h"
#import <NSString-Hashes/NSString+Hashes.h>

NSString *const MSFCipherAppKey = @"34569E09FE7A0AF8E01FB1258B9BCAF2";
NSString *const MSFCipherAppSecret = @"34569E09FE7A0AF8E01FB1258B9BCAF2";

static NSString *const kTimestamp = @"timestamp";
static NSString *const kSign = @"sign";
static NSString *const kAppKey = @"appKey";

@implementation MSFCipher {
	// 服务器本地时间差
	long long transport;
}

- (instancetype)initWithTimestamp:(long long)contestant {
	self = [super init];
	if (!self) {
		return nil;
	}
	_internet = contestant;
	_client = [self bumpstamp];
	
	return self;
}

- (long long)bumpstamp {
	return (long long)([[NSDate date] timeIntervalSince1970] * 1000);
}

- (MSFSignature *)signatureWithPath:(NSString *)path parameters:(NSDictionary *)params {
	if (!params) {
		params = @{};
	}
	NSParameterAssert([params isKindOfClass:NSDictionary.class]);
	NSMutableDictionary *parameters = params.mutableCopy;
	
	transport = self.internet - self.client + self.bumpstamp;
	[parameters setObject:@(transport) forKey:kTimestamp];
	
	NSString *sign = [self signWithPath:path query:params];
	[parameters setObject:sign forKey:kSign];
	
	return [[MSFSignature alloc] initWithDictionary:@{
		kSign: sign,
		kAppKey: MSFCipherAppKey,
		kTimestamp: @(transport)
	} error:nil];
}

#pragma mark - Private

- (NSString *)encodeFromPercentEscapeString:(NSString *)string {
	return (__bridge NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
		NULL,
		(__bridge CFStringRef) string,
		CFSTR(""),
		kCFStringEncodingUTF8
	);
}

- (NSString *)signWithPath:(NSString *)path query:(NSDictionary *)query {
	NSMutableDictionary *parameters = query.mutableCopy;
	[parameters addEntriesFromDictionary:@{kTimestamp: @(transport)}];
	[parameters addEntriesFromDictionary:@{kAppKey: MSFCipherAppKey}];
	
	NSArray *sortedKeys = [parameters.allKeys sortedArrayUsingSelector:@selector(compare:)];
	NSMutableArray *sorted = NSMutableArray.new;
	for (NSString *key in sortedKeys) {
		NSString *keyAndValue = [NSString stringWithFormat:@"%@%@", key,
		 [parameters[key] isKindOfClass:NSString.class] ? [self encodeFromPercentEscapeString:parameters[key]] : parameters[key]];
		[sorted addObject:keyAndValue];
	}
	
	[sorted addObject:MSFCipherAppSecret];
	NSString *string = [sorted componentsJoinedByString:@""];
	
	return [string.md5 uppercaseString];
}

@end
