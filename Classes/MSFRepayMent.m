//
//	MSFRepayMent.m
//	Cash
//	还款
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFRepayMent.h"

@implementation MSFRepayMent

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
		return @{
						 @"repaymentID": @"repayment_id",
						 @"expireDate": @"expire_date",
						 @"allAmount": @"amount",
						 @"contractStatus" : @"contract_status",
						 @"repaymentStatus" : @"repayment_status"
						 };
}

@end
