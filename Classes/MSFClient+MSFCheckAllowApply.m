//
//  MSFClient+MSFCheckAllowApply.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFCheckAllowApply.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFCheckAllowApply.h"

@implementation MSFClient (MSFCheckAllowApply)

- (RACSignal *)fetchCheckAllowApply {
	
	//NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"allow" ofType:@"json"]]];
	
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"loan/allow" parameters:nil];
	
	return [[self enqueueRequest:request resultClass:MSFCheckAllowApply.class] msf_parsedResults];
}

@end
