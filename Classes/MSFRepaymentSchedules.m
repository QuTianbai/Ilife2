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
						 @"contractStatus": @"contractStatus",
						 @"repaymentTime":@"latestDueDate",
						 @"repaymentTotalAmount":@"latestDueMoney",
						 };
}

+ (NSValueTransformer *)contractStatusJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithBlock:^(NSString *contractStatus) {
		return [NSDictionary statusStringForKey:contractStatus];
	}];
}

@end
