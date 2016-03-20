//
//  NSDictionary+MSFKeyValue.m
//  Finance
//
//  Created by 赵勇 on 10/24/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "NSDictionary+MSFKeyValue.h"

@implementation NSDictionary(MSFKeyValue)

+ (NSString *)statusStringForKey:(NSString *)key {
	NSDictionary *dic = @{
		@"A" : @"已还款",
		@"B" : @"已出账",
		@"C" : @"已逾期",
		@"D" : @"还款中",
		@"E" : @"放款中",
		@"F" : @"",
		@"G" : @"审核中",
		@"H" : @"审核未通过",
		@"I" : @"待确认合同",
		@"J" : @"合同已确认",
		@"K" : @"已取消",
		@"L" : @"重传资料",
		@"M" : @"正常",
		@"N" : @"已退货",
		@"O" : @"待支付",
		@"P" : @"已支付",
		@"Q" : @"已支付首付"
	};
	
	return dic[key];
}

+ (NSString *)typeStringForKey:(NSString *)key {
	NSDictionary *dict = @{
		@"1" : @"马上贷",
		@"3" : @"商品贷",
		@"4" : @"信用钱包"
	};
	return dict[key];
}

+ (UIImage *)imageForContractKey:(NSString *)type {
	NSDictionary *dict = @{
		@"1" : @"icon-myorder-app",
		@"3" : @"icon-myorder-bussy",
		@"4" : @"icon-myorder-wallet"
	};
	return [UIImage imageNamed:dict[type]];
}

+ (NSString *)productCodeWithKey:(NSString *)key {
	NSDictionary *dict = @{
		@"1" : @"1101",
		@"3" : @"3101",
		@"4" : @"4102"
		};
	return dict[key]?:@"";
}

@end
