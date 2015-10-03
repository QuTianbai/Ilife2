//
//  MSFClient+MSFSubmitAppyCash.m
//  Finance
//
//  Created by xbm on 15/10/3.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFSubmitAppyCash.h"
#import "MSFSubmitApplyModel.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (MSFSubmitAppyCash)

- (RACSignal *)fetchSubmitWithApplyVO:(MSFApplyCashModel *)infoModel AndAcessory:(NSArray *)AccessoryInfoVO Andstatus:(NSString *)status {
	//NSDictionary *params = [infoModel ]
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"submit" ofType:@"json"]]];
//	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"loan/apply" parameters:@{@"ApplyVO": infoModel, @"AccessoryInfoVO": AccessoryInfoVO, @"applyStatus": status}];
	
	return [[self enqueueRequest:request resultClass:MSFSubmitApplyModel.class] msf_parsedResults];
}

@end
