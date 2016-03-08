//
//  MSFCommodity.m
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCommodity.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation MSFCommodity

//+ (NSSet *)propertyKeys {
//	NSMutableSet *keys = [super.propertyKeys mutableCopy];
//
//	// This is a derived property.
//	[keys removeObject:@keypath(MSFCommodity.new, server)];
//
//	return keys;
//}

+ (NSValueTransformer *)pcsCountJSONTransformer {
	return [self transformer];
}

+ (NSValueTransformer *)cmdtyPriceJSONTransformer {
	return [self transformer];
}

+ (NSValueTransformer *)transformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id x) {
		if ([x isKindOfClass:NSString.class]) {
			return x;
		} else if ([x isKindOfClass:NSNumber.class]) {
			return [x stringValue];
		} else {
			return nil;
		}
	} reverseBlock:^id(NSString *x) {
		return [NSNumber numberWithInteger:x.integerValue];
	}];
}

@end
