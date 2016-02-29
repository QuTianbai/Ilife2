//
// MSFClient+Photos.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Photos.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFPhoto.h"

@implementation MSFClient (Photos)

- (RACSignal *)fetchAdv:(NSString *)type {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		MSFPhoto *photo1 = [[MSFPhoto alloc] initWithURL:[NSURL URLWithString:@"http://www.msxf.com/res/images/banner6.jpg"]];
		[subscriber sendNext:photo1];
		MSFPhoto *photo2 = [[MSFPhoto alloc] initWithURL:[NSURL URLWithString:@"http://www.msxf.com/res/images/banner5.jpg"]];
		[subscriber sendNext:photo2];
		[subscriber sendCompleted];
		return nil;
	}];
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"adv/list" parameters:@{@"type": type}];
	return [[self enqueueRequest:request resultClass:nil] map:^id(NSDictionary *json) {
		return [[MSFPhoto alloc] initWithURLString:json[@"content"]];
	}];
}

@end
