//
//  MSFClient+MSFSocialInsurance.m
//  Finance
//
//  Created by xbm on 15/11/23.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFSocialInsurance.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFSocialInsuranceModel.h"
#import "MSFApplicationResponse.h"

@implementation MSFClient (MSFSocialInsurance)

- (RACSignal *)fetchSubmitSocialInsuranceInfoWithModel:(MSFSocialInsuranceModel *)model {
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:model.dictionaryValue];
	
	[dict removeObjectForKey:@"server"];
	[dict removeObjectForKey:@"objectID"];
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
	NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"append/uploadAppendInfo" parameters:@{
																																																 @"custSocialSecurity": jsonStr
																																																 }];
	
	return [[self enqueueRequest:request resultClass:MSFApplicationResponse.class] msf_parsedResults];
}

@end
