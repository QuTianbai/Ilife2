//
// MSFClient+Inventory.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Inventory.h"
#import "MSFAttachment.h"
#import "MSFInventory.h"
#import "MSFApplicationResponse.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (Inventory)

- (RACSignal *)fetchAttachmentsWithCredit:(MSFApplicationResponse *)credit {
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"attachment/getList" parameters:@{
		@"applyId": credit.applyID ?: @"",
	}];
	return [[self enqueueRequest:request resultClass:MSFAttachment.class] msf_parsedResults];
}

- (RACSignal *)updateInventory:(MSFInventory *)inventory {
	NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:inventory];
//	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:nil];
//	NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//	NSDictionary *params = [NSDictionary dictionaryWithObject:jsonStr forKey:@"attachmentData"];
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"attachment/saveList" parameters:parameters];
//	[request setHTTPMethod:@"POST"];
	
	return [self enqueueRequest:request resultClass:nil];
}

@end
