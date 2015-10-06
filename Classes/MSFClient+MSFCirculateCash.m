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
#import "MSFUtils.h"

@implementation MSFClient (MSFCirculateCash)

- (RACSignal *)fetchCirculateCash {
	
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"cirCulate" ofType:@"json"];
//	
//	NSURL *url = [NSURL fileURLWithPath:path];
//	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/currentloaninfo" parameters:@{@"uniqueId":MSFUtils.uniqueId}];

	//currentloaninfo
	
	return [[self enqueueRequest:request resultClass:MSFCirculateCashModel.class] msf_parsedResults];
	
}

@end
