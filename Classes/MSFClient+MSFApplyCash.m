//
//	MSFClient+MSFApplyCash.m
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+MSFApplyCash.h"
#import "MSFApplicationResponse.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFApplicationForms.h"
#import <objc/runtime.h>

@implementation MSFClient (MSFApplyCash)

- (RACSignal *)fetchApplyCash {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"loans" parameters:nil];
	
	return [[self enqueueRequest:request resultClass:MSFApplicationResponse.class] msf_parsedResults];
}

- (RACSignal *)applyInfoSubmit1:(MSFApplicationForms *)model {
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:model.dictionaryValue];
	[dict removeObjectForKey:@"server"];
	[dict removeObjectForKey:@"loanId"];
	[dict removeObjectForKey:@"objectID"];
	[dict setValue:model.loanId forKey:@"id"];
//	for (NSString *str in [dict allKeys]) {
//		NSString *temp = @"";
//		NSLog(@"%@:%@", str, [dict objectForKey:str]);
//		if ([[dict objectForKey:str] isKindOfClass:[NSNumber class]]) {
//			NSNumber *numStr = dict[str];
//			
//		}
//		if ([[dict objectForKey:str] isEqualToString:@"<null>"]) {
//			[dict setObject:@"" forKey:str];
//		}
//	}
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
	NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	NSDictionary *paramDict = [NSDictionary dictionaryWithObject:jsonStr forKey:@"loans"];
	
	NSMutableURLRequest *request = [self requestWithMethod:@"GET" path:@"loans" parameters:paramDict];
	[request setHTTPMethod:@"POST"];
	
	return [[self enqueueRequest:request resultClass:MSFApplicationResponse.class] msf_parsedResults];
}

@end
