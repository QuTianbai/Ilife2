//
//	MSFRepaymentSchedule.m
//	Cash
//	计划列表
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFRepaymentSchedules.h"
#import "NSDictionary+MSFKeyValue.h"

@implementation MSFRepaymentSchedules

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"contractNum": @"contractNo",
		@"repaymentTime": @"latestDueDate",
		@"repaymentTotalAmount": @"latestDueMoney",
		@"contractType": @"type"
	};
}

+ (NSValueTransformer *)contractStatusJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithBlock:^(NSString *contractStatus) {
		return [NSDictionary statusStringForKey:contractStatus];
	}];
}

+ (NSValueTransformer *)totalOverdueMoneyJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *num) {
		if ([num isKindOfClass:[NSNumber class]]) {
			return num.stringValue;
		}
		return num;
		
	} reverseBlock:^id(NSString *str) {
		return str;
	}];
}

@end
