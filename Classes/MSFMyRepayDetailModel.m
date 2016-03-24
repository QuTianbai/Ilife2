 //
//  MSFMyRepayDetailModel.m
//  Finance
//
//  Created by xbm on 16/2/29.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyRepayDetailModel.h"
#import "MSFCmdtyModel.h"
#import "MSFDrawModel.h"
#import "NSDictionary+MSFKeyValue.h"

@implementation MSFMyRepayDetailModel

+ (NSValueTransformer *)cmdtyListJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFCmdtyModel.class];
}

+ (NSValueTransformer *)withdrawListJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFDrawModel.class];
}

+ (NSValueTransformer *)latestDueMoneyJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class] ? num.stringValue :num;
	} reverseBlock:^id(NSString *str) {
		return str;
	}];
}

+ (NSValueTransformer *)appLmtJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class] ? num.stringValue :num;
	} reverseBlock:^id(NSString *str) {
		return str;
	}];
}

+ (NSValueTransformer *)loanTermJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class] ? num.stringValue :num;
	} reverseBlock:^id(NSString *str) {
		return str;
	}];
}

+ (NSValueTransformer *)totalOverdueMoneyJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class] ? num.stringValue :num;
	} reverseBlock:^id(NSString *str) {
		return str;
	}];
}

+ (NSValueTransformer *)interestJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *num) {
		return [num isKindOfClass:NSNumber.class] ? num.stringValue :num;
	} reverseBlock:^id(NSString *str) {
		return str;
	}];
}

+ (NSValueTransformer *)typeJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithBlock:^id(NSString *value) {
		return [NSDictionary typeStringForKey:value?:@""];
	}];
}

+ (NSValueTransformer *)contractStatusJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithBlock:^id(NSString *value) {
		return [NSDictionary statusStringForKey:value?:@""];
	}];
}

@end
