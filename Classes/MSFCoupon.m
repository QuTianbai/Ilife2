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
		@"ticketName": @"ticketRuleName",
		@"type": @"ticketType",
		@"value": @"faceValue",
	};
}

+ (NSValueTransformer *)effectDateBeginJSONTransformer {
	return [MTLValueTransformer valueTransformerForName:MSFDateValueTransformerName];
}

+ (NSValueTransformer *)effectDateEndJSONTransformer {
	return [MTLValueTransformer valueTransformerForName:MSFDateValueTransformerName];
}

+ (NSValueTransformer *)receiveTimeJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *number) {
		return [NSDate dateWithTimeIntervalSince1970:number.doubleValue / 1000.0];
	} reverseBlock:^id(NSDate *date) {
		return @((long long)([date timeIntervalSince1970] * 1000.0));
	}];
}

@end
