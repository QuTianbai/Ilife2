//
//	MSFRepaymentSchedule.m
//	Cash
//	计划列表
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFRepaymentSchedules.h"

@implementation MSFRepaymentSchedules

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
		return @{
						 @"contractNum": @"contractNo",
						 @"contractStatus": @"contractStatus",
						 @"repaymentTime":@"dueDate",
						 @"repaymentTotalAmount":@"dueMoney",
						 };
}

+ (NSValueTransformer *)contractStatusJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithBlock:^(NSString *contractStatus) {
		NSDictionary *formatter = @{@"A" : @"",
																@"B" : @"审核中",
																@"C" : @"合同未确认",
																@"D" : @"审核未通过",
																@"E" : @"待放款",
																@"F" : @"还款中",
																@"G" : @"已取消",
																@"H" : @"已还款",
																@"I" : @"已逾期",
																@"J" : @"已到期"};
		return formatter[contractStatus];
	}];
}

@end
