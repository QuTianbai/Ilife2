//
// MSFCoupon.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFCoupon.h"
#import "NSValueTransformer+MSFPredefinedTransformerAdditions.h"

@implementation MSFCoupon

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"objectID": @"id",
	};
}

+ (NSValueTransformer *)effectDateBeginJSONTransformer {
	return [MTLValueTransformer valueTransformerForName:MSFDateValueTransformerName];
}

+ (NSValueTransformer *)effectDateEndJSONTransformer {
	return [MTLValueTransformer valueTransformerForName:MSFDateValueTransformerName];
}

+ (NSValueTransformer *)receiveTimeJSONTransformer {
	return [MTLValueTransformer valueTransformerForName:MSFDateValueTransformerName];
}

@end
