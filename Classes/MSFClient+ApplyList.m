//
//	MSFClient+MSFApplyList.m
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+ApplyList.h"
#import "MSFApplyList.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFResponse.h"

@implementation MSFClient (ApplyList)

- (RACSignal *)fetchSpicyApplyList:(NSInteger)type {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"append/applyList" parameters:@{
		@"type" : [@(type) stringValue]
	}];
	return [[[self enqueueRequest:request resultClass:MSFApplyList.class] msf_parsedResults] collect];
}

- (RACSignal *)fetchRepayURLWithAppliList:(MSFApplyList *)applylist {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self requestWithMethod:@"GET" path:@"coresys/cont/contract/pageQuery" parameters:@{
			@"applyId": applylist.appNo
		}];
		[subscriber sendNext:request];
		[subscriber sendCompleted];
		return nil;
	}];
}

- (RACSignal *)fetchRecentApplicaiton:(NSString *)type {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"query/apply" parameters:@{
		@"type" : type
	}];
	return [[[self enqueueRequest:request resultClass:MSFApplyList.class] msf_parsedResults] collect];
}

@end
