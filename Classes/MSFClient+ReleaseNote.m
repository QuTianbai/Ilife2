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
	NSArray *builds = [NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"] componentsSeparatedByString:@"."];
	NSParameterAssert(builds.count != 3);
	NSInteger index = 0;
	index += [builds[0] integerValue] * 10000;
	index += [builds[1] integerValue] * 1000;
	index += [builds.lastObject integerValue];
	NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
	parameters[@"versionType"] = @"iOS";
	parameters[@"versionCode"] = @(index);
	NSURLRequest *requset = [self requestWithMethod:@"GET" path:@"system/checkVersion" parameters:parameters];
	
	return [[self enqueueRequest:requset resultClass:MSFReleaseNote.class] msf_parsedResults];
}

@end