//
//  MSFOrderDetail.m
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFOrderDetail.h"
#import "MSFCommodity.h"
#import "MSFTravel.h"
#import "MSFCompanion.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MSFOrderDetail

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"travel": @"orderTravelDto",
		@"companions": @"travelCompanInfoList",
	};
}

+ (NSSet *)propertyKeys {
	NSMutableSet *keys = [super.propertyKeys mutableCopy];

	// This is a derived property.
	[keys removeObject:@keypath(MSFOrderDetail.new, server)];

	return keys;
}

+ (NSValueTransformer *)travelJSONTransformer {
	return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MSFTravel.class];
}

+ (NSValueTransformer *)companionsJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFCompanion.class];
}

+ (NSValueTransformer *)cmdtyListJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFCommodity.class];
}

+ (NSValueTransformer *)totalAmtJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		 return str;
	 }];
}

+ (NSValueTransformer *)downPmtJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		 return str;
	 }];
}

+ (NSValueTransformer *)totalQuantityJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		 return str;
	 }];
}

+ (NSValueTransformer *)orderTimeJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		NSDate *date = [NSDate dateWithTimeIntervalSince1970:num.longLongValue / 1000.0];
		return [NSDateFormatter msf_stringFromDate:date];
	} reverseBlock:^ id (NSString *str) {
		 return str;
	 }];
}

- (BOOL)validateIsDownPmt:(id *)objectID error:(NSError **)error {
	id object  = *objectID;
	if ([object isKindOfClass:NSNumber.class]) {
		return YES;
	} else if ([object isKindOfClass:NSString.class]) {
		*objectID = @([*objectID boolValue]);
		return YES;
	}
	*objectID = @NO;
	
	return YES;
}

- (BOOL)validateValueAddedSvc:(id *)objectID error:(NSError **)error {
	id object  = *objectID;
	if ([object isKindOfClass:NSNumber.class]) {
		return YES;
	} else if ([object isKindOfClass:NSString.class]) {
		*objectID = @([*objectID boolValue]);
		return YES;
	}
	*objectID = @NO;
	
	return YES;
}

#pragma mark - Custom Accessors

- (BOOL)isCommodity {
	return [self.cartType isEqualToString:@"goods"];
}

@end
