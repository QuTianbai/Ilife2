//
//  MSFClient+Contacts.m
//  Finance
//
//  Created by xbm on 15/9/2.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+Contacts.h"
#import "MSFContactListModel.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (Contacts)

- (RACSignal *)fetchContactsInfoWithAppNO:(NSString *)appNO AndProductNO:(NSString *)productCode AndtemplateType:(NSString *)templateType {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self requestWithMethod:@"POST" path:@"loan/showDetail" parameters:@{
			@"appNo": appNO,
			@"productCode": productCode,
			@"templateType":templateType
		}];
		if ([templateType isEqualToString:@"CASH_CONTRACT"]) {
			// 社保贷合同确认请求参数
			request = [self requestWithMethod:@"POST" path:@"append/showDetail" parameters:@{
				@"appNo": appNO,
				@"productCode": productCode,
				@"templateType": templateType
			}];
		}
		[subscriber sendNext:request];
		[subscriber sendCompleted];
		return nil;
	}];
}

@end
