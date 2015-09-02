//
// MSFAttachment.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAttachment.h"
#import "NSValueTransformer+MSFPredefinedTransformerAdditions.h"

@implementation MSFAttachment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"fileID": @"fileId",
		@"name": @"attachmentName",
		@"type": @"attachmentType",
		@"plain": @"attachmentTypePlain",
		@"applyID": @"applyId",
		@"applyNo": @"applyNo",
		@"commentURL": @"comment",
		@"objectID": @"id",
		@"additionDate": @"rawAddTime",
		@"updatedDate": @"rawUpdateTime",
		@"status": @"status",
		@"contentType": @"type",
	};
}

- (BOOL)validateFileID:(id *)objectID error:(NSError **)error {
	id object  = *objectID;
	if ([object isKindOfClass:NSString.class]) {
		return YES;
	} else if ([object isKindOfClass:NSNumber.class]) {
		*objectID = [*objectID stringValue];
		return YES;
	}
	
	return *objectID == nil;
}

- (BOOL)validateApplyID:(id *)objectID error:(NSError **)error {
	id object  = *objectID;
	if ([object isKindOfClass:NSString.class]) {
		return YES;
	} else if ([object isKindOfClass:NSNumber.class]) {
		*objectID = [*objectID stringValue];
		return YES;
	}
	
	return *objectID == nil;
}

- (BOOL)validateObjectID:(id *)objectID error:(NSError **)error {
	id object  = *objectID;
	if ([object isKindOfClass:NSString.class]) {
		return YES;
	} else if ([object isKindOfClass:NSNumber.class]) {
		*objectID = [*objectID stringValue];
		return YES;
	}
	
	return *objectID == nil;
}

+ (NSValueTransformer *)commentURLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)additionDateJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MSFDateValueTransformerName];
}

+ (NSValueTransformer *)updatedDateJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MSFDateValueTransformerName];
}

- (BOOL)isEqual:(MSFAttachment *)other {
	if (other == self) {
		return YES;
	} else if (![super isEqual:other]) {
		return NO;
	} else {
		return [other.objectID isEqualToString:self.objectID] || [other.contentURL isEqual:self.contentURL];
	}
}

- (NSUInteger)hash {
	return self.objectID.hash ^ self.contentURL.hash;
}

@end
