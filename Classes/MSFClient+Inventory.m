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
	NSMutableArray *attachments = [[NSMutableArray alloc] init];
	[inventory.attachments enumerateObjectsUsingBlock:^(MSFAttachment *obj, NSUInteger idx, BOOL *stop) {
		[attachments addObject:@{
			@"fileId": obj.contentID,
			@"attachmentName": obj.contentName,
			@"attachmentType": obj.type,
			@"attachmentTypePlain": obj.plain,
		}];
	}];
	NSMutableDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:inventory].mutableCopy;
	[parameters setObject:attachments forKey:@"fileList"];
	[parameters removeObjectForKey:@"server"];
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"attachment/saveList" parameters:parameters];
	
	return [self enqueueRequest:request resultClass:nil];
}

@end
