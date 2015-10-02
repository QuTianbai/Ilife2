//
// MSFAuthorizeResponse.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAuthorizeResponse.h"

@implementation MSFAuthorizeResponse

+ (NSValueTransformer *)uniqueIdJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		 return str;
	 }];
}

+ (NSValueTransformer *)clientTypeJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *num) {
		return [num isKindOfClass:[NSString class]] ? @(num.integerValue) : num;
	} reverseBlock:^ id (NSString *str) {
		 return str;
	 }];
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"uniqueId": @"uniqueId",
		@"clientType": @"custType",
	};
}

@end
