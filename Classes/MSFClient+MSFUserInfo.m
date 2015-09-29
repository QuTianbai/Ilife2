//
//  MSFClient+MSFUserInfo.m
//  Finance
//
//  Created by 赵勇 on 9/29/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFUserInfo.h"
#import "MSFUserInfoModel.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient(MSFUserInfo)

- (RACSignal *)fetchUserInfo {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"cust/getInfo" parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFUserInfoModel.class] msf_parsedResults];
}

@end
