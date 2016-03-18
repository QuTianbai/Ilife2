//
//  MSFDrawModel.m
//  Finance
//
//  Created by xbm on 16/2/29.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFDrawModel.h"

@implementation MSFDrawModel

+ (NSValueTransformer *)withdrawMoneyJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class] ? num.stringValue : num;
	} reverseBlock:^id(NSString *str) {
		return str;
	}];
}

@end
