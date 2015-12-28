//
//  MSFCart.m
//  Finance
//
//  Created by 赵勇 on 12/24/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFCart.h"
#import "MSFCommodity.h"

@implementation MSFCart

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
