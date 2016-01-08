//
// MSFClient+ReleaseNote.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+ReleaseNote.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFReleaseNote.h"

@implementation MSFClient (ReleaseNote)

- (RACSignal *)fetchReleaseNote {
	NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
	parameters[@"versionType"] = @"iOS";
	parameters[@"versionCode"] = ^{
		NSArray *builds = [NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"] componentsSeparatedByString:@"."];
		__block NSInteger x = 0 ;
		[builds enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
			x += (NSUInteger)pow(10, idx + 1) * [obj integerValue];
		}];
		return @(x);
	}();
	NSURLRequest *requset = [self requestWithMethod:@"GET" path:@"checkVersion" parameters:parameters];
	
	return [[self enqueueRequest:requset resultClass:MSFReleaseNote.class] msf_parsedResults];
}

@end