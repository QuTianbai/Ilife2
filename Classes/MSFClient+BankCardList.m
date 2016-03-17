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
#import "MSFSupportBankModel.h"
#import "MSFWalletRepayViewModel.h"

@implementation MSFClient (BankCardList)

- (RACSignal *)fetchBankCardList {
	if (!self.user.isAuthenticated) return RACSignal.empty;
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"bankcard/bindingList" parameters:@{
									@"uniqueId": self.user.uniqueId?:@""
	}];
	return [[self enqueueRequest:request resultClass:MSFBankCardListModel.class] msf_parsedResults];
}

- (RACSignal *)fetchSupportBankInfo {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"bankcard/supportBank" parameters:nil];
	return [[self enqueueRequest:request resultClass:nil] map:^id(MSFResponse *value) {
		return value.parsedResult[@"supportBank"];
	}];
}

- (RACSignal *)fetchSupportBankInfoNew {
    NSURLRequest *request = [self requestWithMethod:@"GET" path:@"bankcard/supportBank" parameters:nil];
    return [[self enqueueRequest:request resultClass:MSFSupportBankModel.class] msf_parsedResults];
}

- (RACSignal *)fetchRepayInformationSignal {
    NSURLRequest *request = [self requestWithMethod:@"GET" path:@"query/repaymentPlan" parameters:@{@"type":@"4", @"contractNo": @""}];
    return [[self enqueueRequest:request resultClass:MSFWalletRepayViewModel.class] msf_parsedResults];
}

@end
