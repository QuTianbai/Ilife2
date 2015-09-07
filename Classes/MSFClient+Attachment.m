//
// MSFClient+Attachment.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Attachment.h"
#import "MSFAttachment.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (Attachment)

- (RACSignal *)uploadAttachment:(MSFAttachment *)attachment {
	NSMutableURLRequest *request =
	[self requestWithMethod:@"POST" path:@"upload" parameters:nil
		constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
			NSString *fileName = [attachment.fileURL lastPathComponent];
			NSString *mimeType = @"image/*";
			[formData appendPartWithFileData:[NSData dataWithContentsOfURL:attachment.fileURL] name:@"image" fileName:fileName mimeType:mimeType];
	}];
	
	return [[self enqueueRequest:request resultClass:MSFAttachment.class] msf_parsedResults];
}

- (RACSignal *)downloadAttachment:(MSFAttachment *)attachment {
	NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:attachment];
	NSURLRequest *request = [self requestWithMethod:@"POST" path:@"download" parameters:parameters];
	return [self enqueueRequest:request resultClass:nil];
}

@end