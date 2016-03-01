//
//  MSFClient+SubmitAppyCash.m
//  Finance
//
//  Created by xbm on 15/10/3.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+SubmitAppyCash.h"
#import "MSFSubmitApplyModel.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFApplyCashModel.h"
#import "MSFUser.h"

@implementation MSFClient (SubmitAppyCash)

- (RACSignal *)fetchSubmitWithApplyVO:(MSFApplyCashModel *)infoModel AndAcessory:(NSArray *)AccessoryInfoVO Andstatus:(NSString *)status {
	infoModel.applyStatus = 0;
	if ([status isEqualToString:@"1"]) {
		infoModel.applyStatus = 1;
	}
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:infoModel.dictionaryValue];
	[dict removeObjectForKey:@"server"];
	[dict removeObjectForKey:@"objectID"];
	
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
	NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	NSData *arrayData = [NSJSONSerialization dataWithJSONObject:AccessoryInfoVO options:NSJSONWritingPrettyPrinted error:nil];
	NSString *accesory = [[NSString alloc] initWithData:arrayData encoding:NSUTF8StringEncoding]; 
	
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"loan/apply" parameters:@{
		@"ApplyVO": jsonStr,
		@"AccessoryInfoVO": accesory,
		@"applyStatus": status,
		@"uniqueId":self.user.uniqueId
	}];
	
	return [[self enqueueRequest:request resultClass:MSFSubmitApplyModel.class] msf_parsedResults];
}

@end
