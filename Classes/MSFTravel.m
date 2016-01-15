//
// MSFTravel.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFTravel.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

@implementation MSFTravel

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
