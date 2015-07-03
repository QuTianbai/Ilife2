//
//  MSFStaging.m
//  Cash
//  期
//  Created by xutian on 15/5/14.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFInstallment.h"

@implementation MSFInstallment

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"installmentID": @"installment_id",
             @"planID": @"plan_id",
             @"loanID": @"loan_id",
             @"thePrincipal": @"repayment_amount",
             @"interest": @"interest_rate",
             @"serviceCharge": @"service_charges",
             @"totalMoney": @"repayment_total_amount",
             };
}

@end
