//
// MSFInventory.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFInventory.h"
#import "MSFAttachment.h"

@implementation MSFInventory

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"objectID": @"applyId",
		@"applyNo": @"applyNo",
		@"attachments": @"fileList",
	};
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

+ (NSValueTransformer *)attachmentsJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFAttachment.class];
}

@end
