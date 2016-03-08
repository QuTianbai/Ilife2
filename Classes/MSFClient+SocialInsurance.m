//
//  MSFClient+MSFSocialInsurance.m
//  Finance
//
//  Created by xbm on 15/11/23.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+SocialInsurance.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFSocialInsuranceModel.h"
#import "MSFApplicationResponse.h"
#import "MSFSubmitApplyModel.h"

@implementation MSFClient (SocialInsurance)

- (RACSignal *)fetchSaveSocialInsuranceInfoWithModel:(MSFSocialInsuranceModel *)model {
	return RACSignal.empty;
}

- (RACSignal *)fetchSubmitSocialInsuranceInfoWithModel:(NSDictionary *)dict AndAcessory:(NSArray *)AccessoryInfoVO Andstatus:(NSString *)status {
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[dict mtl_dictionaryByAddingEntriesFromDictionary:@{@"appNo": @""}] options:NSJSONWritingPrettyPrinted error:nil];
	NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	
	NSData *arrayData = [NSJSONSerialization dataWithJSONObject:AccessoryInfoVO options:NSJSONWritingPrettyPrinted error:nil];
	NSString *accesory = [[NSString alloc] initWithData:arrayData encoding:NSUTF8StringEncoding];
	
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"append/apply" parameters:@{
									@"applyVO": jsonStr,
									@"accessoryInfoVO": accesory,
									@"applyStatus": status
									}];
	
	return [[self enqueueRequest:request resultClass:MSFSubmitApplyModel.class] msf_parsedResults];
}

- (RACSignal *)fetchGetSocialInsuranceInfo {
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"append/loadAppendInfo" parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFSocialInsuranceModel.class] msf_parsedResults];
}

- (RACSignal *)confirmInsuranceSignal {
	return [RACSignal return:[[MSFSubmitApplyModel alloc] initWithDictionary:@{@"appNo": @""} error:nil]];
}

@end
