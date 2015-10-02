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
	parameters[@"versionCode"] = [[NSBundle mainBundle].infoDictionary[@"CFBundleVersion"] stringByReplacingOccurrencesOfString:@"." withString:@""];
	parameters[@"versionType"] = @"iOS";
	NSURLRequest *requset = [self requestWithMethod:@"GET" path:@"checkVersion" parameters:parameters];
	
	return [[self enqueueRequest:requset resultClass:MSFReleaseNote.class] msf_parsedResults];
}

@end