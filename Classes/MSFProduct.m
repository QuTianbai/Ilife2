//
//	MSFMonths.m
//	Cash
//
//	Created by xbm on 15/5/27.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFProduct.h"

@implementation MSFProduct

+ (NSValueTransformer *)productIdJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *num) {
		return num.stringValue;
	} reverseBlock:^id(NSString *str) {
		if (str==nil) {
			return [NSDecimalNumber decimalNumberWithString:str];
		}
		
		return nil;
	}];
}

+ (NSValueTransformer *)periodJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *num) {
		return num.stringValue;
	} reverseBlock:^id(NSString *str) {
		if (str==nil) {
			return [NSDecimalNumber decimalNumberWithString:str];
		}
		
		return nil;
	}];
}

- (BOOL)validatePeriod:(id *)period error:(NSError **)error {
	id temp = *period;
	if ([temp isKindOfClass:NSString.class]) {
		return YES;
	} else if ([temp isKindOfClass:NSNumber.class]) {
		*period = [temp stringValue];
		return YES;
	}
	
	return *period == nil;
}

- (BOOL)validateProductId:(id *)productId error:(NSError **)error {
	id product = *productId;
	if ([product isKindOfClass:NSString.class]) {
		return YES;
	} else if ([product isKindOfClass:NSNumber.class]) {
		*productId = [product stringValue];
		return YES;
	}
	
	return *productId == nil;
}

#pragma mark - MSFSelectionItem

- (NSString *)title {
	return [self.period stringByAppendingString:@"期"];
}

- (NSString *)subtitle {
	return @"";
	//return self.productName;
}

@end
