//
//  MSFClient+BankCardList.m
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+BankCardList.h"
#import "MSFBankCardListModel.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFUser.h"
#import "MSFResponse.h"

@implementation MSFClient (BankCardList)

- (RACSignal *)fetchBankCardList {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"bankcard/bindingList" parameters:@{
		@"uniqueId": self.user.objectID
	}];
	return [[self enqueueRequest:request resultClass:MSFBankCardListModel.class] msf_parsedResults];
}

- (RACSignal *)fetchSupportBankInfo {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"bankcard/supportBank" parameters:nil];
	return [[self enqueueRequest:request resultClass:nil] map:^id(MSFResponse *value) {
		return value.parsedResult[@"supportBank"];
	}];
}

@end
