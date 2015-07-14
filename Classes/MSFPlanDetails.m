//
//	MSFPlanDetails.m
//	Cash
//	计划详情
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFPlanDetails.h"

@implementation MSFPlanDetails

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
		return @{
						 @"planID": @"plan_id",
						 @"time": @"repayment_time",
						 @"repaymentAmount": @"repayment_amount",
						 @"interest": @"interest_rate",
						 @"serviceCharge": @"service_charges",
						 @"totalMoney": @"repayment_total_amount",
						 };
}

@end
