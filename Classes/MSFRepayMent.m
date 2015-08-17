//
//	MSFRepayMent.m
//	Cash
//	还款
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFRepayMent.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

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

+ (NSValueTransformer *)expireDateJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(NSString *string) {
		return [NSDateFormatter msf_Chinese_stringFromDateString:string];
	}];
}

@end
