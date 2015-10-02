//
// MSFReleaseNote.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFReleaseNote.h"
#import "NSValueTransformer+MSFPredefinedTransformerAdditions.h"

@implementation MSFReleaseNote

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"status": @"status",
		@"versionCode": @"versionCode",
		@"versionName": @"versionName",
		@"updatedURL": @"updateUrl",
		@"summary": @"description",
		@"updatedDate": @"published",
		@"timestamp": @"timestamp",
	};
}

+ (NSValueTransformer *)updatedURLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)updatedDateJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MSFDateValueTransformerName];
}

+ (NSValueTransformer *)timestampJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		 return str;
	 }];
}

@end
