//
//  MSFOrder.m
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFOrder.h"
#import "MSFOrderDetail.h"
#import "NSDictionary+MSFKeyValue.h"

@implementation MSFOrder

+ (NSValueTransformer *)orderListJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFOrderDetail.class];
}

+ (NSValueTransformer *)countJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		 return str;
	 }];
}

+ (NSValueTransformer *)pageSizeJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		 return str;
	 }];
}

+ (NSValueTransformer *)pageNoJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		 return str;
	 }];
}

#pragma mark new version

+ (NSValueTransformer *)loanFixedAmtJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		return str;
	}];
}

+ (NSValueTransformer *)statusJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithBlock:^id(NSString *key) {
		return [NSDictionary statusStringForKey:key];
	}];
}

@end
