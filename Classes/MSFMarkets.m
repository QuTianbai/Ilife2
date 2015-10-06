//
//  MSFMarkets.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFMarkets.h"
#import "MSFTeams2.h"

@implementation MSFMarkets

+ (NSValueTransformer *)teamsJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFTeams2.class];
}

+ (NSValueTransformer *)allMinAmountJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSString *num) {
		return num.intValue>=0?num:@"";
	} reverseBlock:^id(NSString *str) {
		if (str==nil) {
			return [NSDecimalNumber decimalNumberWithString:str];
		}
		
		return nil;
	}];
}

+ (NSValueTransformer *)allMaxAmountJSONTransformer {
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
