//
// MSFClient+Photos.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Photos.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFPhoto.h"
#import "MSFResponse.h"

@implementation MSFClient (Photos)

- (RACSignal *)fetchAdv:(NSString *)type {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"adv/list" parameters:@{@"type": type}];
	return [[self enqueueRequest:request resultClass:nil] map:^id(MSFResponse *response) {
		return [[MSFPhoto alloc] initWithURLString:response.parsedResult[@"filePath"]];
	}];
}

@end
