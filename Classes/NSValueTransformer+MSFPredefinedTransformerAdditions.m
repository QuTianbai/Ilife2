//
//  NSValueTransformer+MSFPredefinedTransformerAdditions.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "NSValueTransformer+MSFPredefinedTransformerAdditions.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import <Mantle/MTLValueTransformer.h>

NSString *const MSFDateValueTransformerName = @"OCTDateValueTransformerName";

@implementation NSValueTransformer (MSFPredefinedTransformerAdditions)

#pragma mark Category Loading

+ (void)load {
	@autoreleasepool {
		MTLValueTransformer *dateValueTransformer = [MTLValueTransformer
			reversibleTransformerWithForwardBlock:^ id (id dateOrDateString) {
				// Some old model versions would serialize NSDates directly, so
				// handle that case too.
				if ([dateOrDateString isKindOfClass:NSDate.class]) {
					return dateOrDateString;
				} else if ([dateOrDateString isKindOfClass:NSString.class]) {
					return [NSDateFormatter msf_dateFromString:dateOrDateString];
				} else {
					return nil;
				}
			}
			reverseBlock:^ id (NSDate *date) {
				if (![date isKindOfClass:NSDate.class]) return nil;
				return [NSDateFormatter msf_stringFromDate:date];
			}];
		
		[NSValueTransformer setValueTransformer:dateValueTransformer forName:MSFDateValueTransformerName];
	}
}

@end
