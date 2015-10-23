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
	return [MTLValueTransformer transformerWithBlock:^id(NSNumber *number) {
		return [NSDate dateWithTimeIntervalSince1970:number.doubleValue / 1000.0];
	}];
}

+ (NSValueTransformer *)endDateJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(NSNumber *number) {
		return [NSDate dateWithTimeIntervalSince1970:number.doubleValue / 1000.0];
	}];
}

@end
