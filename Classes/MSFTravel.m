//
// MSFTravel.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFTravel.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MSFTravel

+ (NSSet *)propertyKeys {
	NSMutableSet *keys = [super.propertyKeys mutableCopy];

	// This is a derived property.
	[keys removeObject:@keypath(MSFTravel.new, objectID)];
	[keys removeObject:@keypath(MSFTravel.new, server)];

	return keys;
}

+ (NSValueTransformer *)departureTimeJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *number) {
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:number.doubleValue / 1000.0];
		return [NSDateFormatter msf_stringFromDate:date];
	} reverseBlock:^id(NSString *string) {
		NSDate *date = [NSDateFormatter msf_dateFromString:string];
		return @((long long)([date timeIntervalSince1970] * 1000));
	}];
}

+ (NSValueTransformer *)returnTimeJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *number) {
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:number.doubleValue / 1000.0];
		return [NSDateFormatter msf_stringFromDate:date];
	} reverseBlock:^id(NSString *string) {
		NSDate *date = [NSDateFormatter msf_dateFromString:string];
		return @((long long)([date timeIntervalSince1970] * 1000));
	}];
}

+ (NSValueTransformer *)travelNumJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *number) {
		return [number isKindOfClass:[NSNumber class]]? number.stringValue : number;
	} reverseBlock:^id(NSString *str) {
		return str;
	}];
}

+ (NSValueTransformer *)travelKidsNumJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *number) {
		return [number isKindOfClass:[NSNumber class]]? number.stringValue : number;
	} reverseBlock:^id(NSString *str) {
		return str;
	}];
}

@end
