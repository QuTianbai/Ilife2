//
//  MSFClient+MSFBankCardList.m
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFBankCardList.h"
#import "MSFBankCardListModel.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFUser.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation MSFClient (MSFBankCardList)

- (RACSignal *)fetchBankCardList {
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"bankCardList" ofType:@"json"];
//	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]];
//	return [[self enqueueRequest:request resultClass:MSFBankCardListModel.class] msf_parsedResults];
	
		NSURLRequest *request = [self requestWithMethod:@"GET" path:@"bankcard/bindingList" parameters:@{@"uniqueId":self.user.uniqueId}];
		return [[self enqueueRequest:request resultClass:MSFBankCardListModel.class] msf_parsedResults];
}

@end
