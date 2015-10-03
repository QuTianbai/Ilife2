//
// MSFAttachment.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAttachment.h"
#import <libextobjc/extobjc.h>
#import "NSValueTransformer+MSFPredefinedTransformerAdditions.h"

@interface MSFAttachment ()

@property (nonatomic, assign, readwrite) BOOL isPlaceholder;

@end

@implementation MSFAttachment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"objectID": @"fileId",
		@"applyID": @"applyId",
		@"applyNo": @"applyNo",
		@"name": @"attachmentName",
		@"type": @"attachmentType",
		@"plain": @"attachmentTypePlain",
		@"commentURL": @"comment",
		@"fileID": @"fileId",
		@"fileName": @"fileName",
		@"additionDate": @"rawAddTime",
		@"updatedDate": @"rawUpdateTime",
		@"status": @"status",
		@"contentID": @"id",
		@"contentName": @"name",
		@"contentType": @"type",
	};
}

+ (NSSet *)propertyKeys {
	NSMutableSet *keys = [super.propertyKeys mutableCopy];

	// This is a derived property.
	[keys removeObject:@keypath(MSFAttachment.new, isPlaceholder)];

	return keys;
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
		return [other.objectID isEqualToString:self.objectID];
	}
}

- (NSUInteger)hash {
	return self.objectID.hash ^ self.thumbURL.hash;
}

@end
