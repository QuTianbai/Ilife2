//
//  MSFSocialInsuranceModel.m
//  Finance
//
//  Created by xbm on 15/11/20.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSocialInsuranceModel.h"

@implementation MSFSocialInsuranceModel

+ (NSValueTransformer *)empEdwMonthsJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		return str;
	}];
}

+ (NSValueTransformer *)empMdcMonthsJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		return str;
	}];
}

+ (NSValueTransformer *)rsdtOldInsuYearsJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		return str;
	}];
}

+ (NSValueTransformer *)rsdtMdcInsuYearsJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		return str;
	}];
}

@end
