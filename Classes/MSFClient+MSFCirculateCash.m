//
//  MSFClient+MSFCirculateCash.m
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFCirculateCash.h"
#import "MSFCirculateCashModel.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFUser.h"

@implementation MSFClient (MSFCirculateCash)

- (RACSignal *)fetchCirculateCash {
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"append/currentloaninfo" parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFCirculateCashModel.class] msf_parsedResults];
}

@end
