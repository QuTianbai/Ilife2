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
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"contract/confirm" parameters:@{
		@"appNo":appNO,
		@"productCd":productCode
	}];
	
	// 以3开头的的逻辑合同确认流程, 采用三步确认，最终的确认调用 ｀loan/confirmOrder`
//	if ([productCode hasPrefix:@"3"]) {
//		request = [self requestWithMethod:@"POST" path:@"loan/confirmOrder" parameters:@{
//			@"appNo":appNO
//		}];
//	}
	
	return [[self enqueueRequest:request resultClass:MSFConfirmContractModel.class] msf_parsedResults];
}

@end