//
//  MSFContactListModel.m
//  Finance
//
//  Created by xbm on 15/9/2.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFContactListModel.h"

@implementation MSFContactListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"contactID": @"id"
	};
}

+ (NSValueTransformer *)contactIDJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *num) {
		return num.stringValue;
	} reverseBlock:^id(NSString *str) {
		if (str == nil) {
			return [NSDecimalNumber decimalNumberWithString:str];
		}
		return nil;
	}];
}

+ (NSValueTransformer *)contLoanApplyIdJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *num) {
		return num.stringValue;
	} reverseBlock:^id(NSString *str) {
		if (str == nil) {
			return [NSDecimalNumber decimalNumberWithString:str];
		}
		return nil;
	}];
}

@end
