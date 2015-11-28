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

@implementation MSFClient (MSFCirculateCash)

- (RACSignal *)fetchCirculateCash:(NSString *)type {
	NSDictionary *param = nil;
	if (type) {
		param = @{@"type" : type};
	}
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"aappend/currentloaninfo" parameters:param];
	return [[self enqueueRequest:request resultClass:MSFCirculateCashModel.class] msf_parsedResults];
}

@end
