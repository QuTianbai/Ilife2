//
//  MSFTeams2.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFTeams2.h"
#import "MSFTeam.h"

@implementation MSFTeams2

+ (NSValueTransformer *)teamJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFTeam.class];
}

+ (NSValueTransformer *)minAmountJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *num) {
		return num.intValue>=0?num:@"";
	} reverseBlock:^id(NSString *str) {
		if (str==nil) {
			return [NSDecimalNumber decimalNumberWithString:str];
		}
		
		return nil;
	}];
}

+ (NSValueTransformer *)maxAmountJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *num) {
		return num.intValue>=0?num:@"";
	} reverseBlock:^id(NSString *str) {
		if (str==nil) {
			return [NSDecimalNumber decimalNumberWithString:str];
		}
		
		return nil;
	}];
}

@end
