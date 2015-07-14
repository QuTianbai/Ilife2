//
//  MSFClient+MSFApplyList.m
//  Cash
//
//  Created by xbm on 15/5/16.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+ApplyList.h"
#import "MSFApplyList.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (ApplyList)

- (RACSignal *)fetchApplyList {
  NSMutableDictionary *parameters = NSMutableDictionary.dictionary;
  NSURLRequest *request = [self requestWithMethod:@"GET" path:@"loans" parameters:parameters];
  
  return [[self enqueueRequest:request resultClass:MSFApplyList.class] msf_parsedResults];
}

- (RACSignal *)fetchRepayURLWithAppliList:(MSFApplyList *)applylist {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self requestWithMethod:@"GET" path:@"coresys/cont/contract/pageQuery" parameters:@{@"applyId": applylist.loan_id}];
		[subscriber sendNext:request.URL];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end
