//
//  MSFClient+Contacts.m
//  Finance
//
//  Created by xbm on 15/9/2.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+Contacts.h"
#import "MSFContactListModel.h"
#import "RACSignal+MSFClientAdditions.h"
//#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MSFClient (Contacts)

- (RACSignal *)fetchContacts {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"contract/pageQuery" parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFContactListModel.class] msf_parsedResults];
}

- (RACSignal *)fetchContactsInfoWithID:(NSString *)contractID {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self requestWithMethod:@"POST" path:@"contract/showContract" parameters:@{@"contractId":contractID}];
		[subscriber sendNext:request];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end
