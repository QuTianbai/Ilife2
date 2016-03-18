//
// MSFClient+Advers.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Advers.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFAdver.h"

@implementation MSFClient (Advers)

- (RACSignal *)fetchAdverWithCategory:(NSString *)category {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSArray *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MSFAdverJson" ofType:@"json"]] options:kNilOptions error:nil];
		NSArray *arr = [MTLJSONAdapter modelsOfClass:MSFAdver.class fromJSONArray:json error:nil];
		[subscriber sendNext:arr];
		[subscriber sendCompleted];
		return nil;
	}];
/*
	NSString *path = [NSString stringWithFormat:@"ads/%@", category];
	NSURLRequest *request = [self requestWithMethod:@"GET" path:path parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFAdver.class] msf_parsedResults];
 */
}

@end
