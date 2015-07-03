//
//  MSFRepaymentSchedule.m
//  Cash
//  计划列表
//  Created by xutian on 15/5/15.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFRepaymentSchedules.h"

@implementation MSFRepaymentSchedules

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"contractNum": @"contract_no",
             @"contractStatus": @"contract_status",
             @"repaymentTime":@"repayment_time",
             @"repaymentTotalAmount":@"repayment_total_amount",
             };
}

@end
