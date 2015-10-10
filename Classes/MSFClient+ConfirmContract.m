//
//  MSFClient+ConfirmContract.m
//  Finance
//
//  Created by xbm on 15/9/3.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+ConfirmContract.h"
#import "MSFConfirmContractModel.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (ConfirmContract)

- (RACSignal *)fetchConfirmContractWithAppNO:(NSString *)appNO AndProductNO:(NSString *)productCode AndtemplateType:(NSString *)templateType {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"loan/showDetail" parameters:@{@"appNo":appNO, @"productCode":productCode,@"templateType":templateType}];
	
	return [[self enqueueRequest:request resultClass:MSFConfirmContractModel.class] msf_parsedResults];
}

@end