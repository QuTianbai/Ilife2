//
//  MSFCart.m
//  Finance
//
//  Created by 赵勇 on 12/24/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCart.h"
#import "MSFCommodity.h"
#import "MSFTravel.h"
#import "MSFCompanion.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

NSString *const MSFCartCommodityIdentifier = @"goods";
NSString *const MSFCartTravelIdentifier = @"travel";

@implementation MSFCart

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"travel": @"orderTravelDto",
		@"companions": @"travelCompanInfoList",
	};
}

+ (NSSet *)propertyKeys {
	NSMutableSet *keys = [super.propertyKeys mutableCopy];

	// This is a derived property.
	[keys removeObject:@keypath(MSFCart.new, server)];

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
	return [self transformer];
}

+ (NSValueTransformer *)totalQuantityJSONTransformer {
	return [self transformer];
}

+ (NSValueTransformer *)minDownPmtJSONTransformer {
	return [self transformer];
}

+ (NSValueTransformer *)maxDownPmtJSONTransformer {
	return [self transformer];
}

+ (NSValueTransformer *)isDownPmtJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *string) {
		return [string isEqualToString:@"1"] ? @YES : @NO;
	} reverseBlock:^id(NSNumber *number) {
		return number.boolValue ? @"1" : @"0";
	}];
}

+ (NSValueTransformer *)transformer {
	return [MTLValueTransformer transformerWithBlock:^id(id x) {
		if ([x isKindOfClass:NSString.class]) {
			return x;
		} else if ([x isKindOfClass:NSNumber.class]) {
			return [x stringValue];
		} else {
			return nil;
		}
	}];
}

#pragma mark - Custom Accessors

- (BOOL)isCommodity {
	return [self.cartType isEqualToString:@"goods"];
}

@end
