//
//  MSFClient+CheckTradePassword.m
//  Finance
//
//  Created by xbm on 15/9/30.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+CheckTradePassword.h"
#import "MSFCheckHasTradePasswordModel.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFUser.h"

@implementation MSFClient (CheckTradePassword)

- (RACSignal *)fetchCheckTradePassword {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"transPassword/checkset" parameters:@{@"uniqueId":self.user.uniqueId}];
	return [[self enqueueRequest:request resultClass:MSFCheckHasTradePasswordModel.class] msf_parsedResults];
}

@end
