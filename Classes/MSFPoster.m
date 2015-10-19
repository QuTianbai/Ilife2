//
// MSFPoster.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFPoster.h"
#import "NSValueTransformer+MSFPredefinedTransformerAdditions.h"

@implementation MSFPoster

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"objectID": @"id",
		@"photoURL": @"picUrl",
		@"startDate": @"timeStart",
		@"endDate": @"timeEnd",
	};
}

+ (NSValueTransformer *)photoURLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)startDateJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MSFDateValueTransformerName];
}

+ (NSValueTransformer *)endDateJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MSFDateValueTransformerName];
}

@end
