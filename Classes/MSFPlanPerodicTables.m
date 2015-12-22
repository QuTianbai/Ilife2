//
//	MSFPlanPerodicTable.m
//	Cash
//	计划期列表
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFPlanPerodicTables.h"

@implementation MSFPlanPerodicTables

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{
		@"contractNum": @"contract_no",
		@"repaymentTime": @"repayment_time",
		@"repaymentAmount": @"repayment_amount",
		@"amountType": @"amount_type",
		@"contractStatus": @"contract_status",
	};
}

@end
