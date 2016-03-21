//
//  MSFTrial.m
//  Finance
//
//  Created by 赵勇 on 12/25/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFTrial.h"

@implementation MSFTrial

+ (NSValueTransformer *)loanFixedAmtJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?[NSString stringWithFormat:@"%.2f", num.doubleValue]:num;
	} reverseBlock:^ id (NSString *str) {
		 return str;
	 }];
}

+ (NSValueTransformer *)lifeInsuranceAmtJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?[NSString stringWithFormat:@"%.2f", num.doubleValue]:num;
	} reverseBlock:^ id (NSString *str) {
		 return str;
	 }];
}

+ (NSValueTransformer *)loanTermJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		 return str;
	 }];
}

+ (NSValueTransformer *)promIdJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class]?num.stringValue:num;
	} reverseBlock:^ id (NSString *str) {
		 return str;
	 }];
}

@end
