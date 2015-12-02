//
// MSFClient+Inventory.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Inventory.h"

@implementation MSFClient (Inventory)

- (RACSignal *)submitInventoryWithApplicaitonNo:(NSString *)applicationNo accessories:(NSDictionary *)accessories {
	NSParameterAssert(applicationNo);
	NSData *data = [NSJSONSerialization dataWithJSONObject:accessories options:NSJSONWritingPrettyPrinted error:nil];
	NSString *JSONString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"append/mendFile" parameters:@{
		@"accessoryInfoVO": JSONString,
		@"applyNo": applicationNo,
	}];
	return [self enqueueRequest:request resultClass:nil];
}

@end
