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
	return [MTLValueTransformer transformerWithBlock:^id(NSNumber *number) {
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:number.doubleValue / 1000.0];
		return [NSDateFormatter msf_stringFromDate:date];
	}];
}

+ (NSValueTransformer *)returnTimeJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(NSNumber *number) {
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:number.doubleValue / 1000.0];
		return [NSDateFormatter msf_stringFromDate:date];
	}];
}

@end
