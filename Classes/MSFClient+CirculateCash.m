//
//  MSFClient+CirculateCash.m
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+CirculateCash.h"
#import "MSFCirculateCashModel.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (CirculateCash)

- (RACSignal *)fetchCirculateCash:(NSString *)type {
	type = type ?: @"";
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"append/currentloaninfo" parameters:@{@"type" : type}];
	return [[self enqueueRequest:request resultClass:MSFCirculateCashModel.class] msf_parsedResults];
}

@end
