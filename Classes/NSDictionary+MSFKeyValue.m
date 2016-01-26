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
		@"B" : @"已到期",
		@"C" : @"已逾期",
		@"D" : @"还款中",
		@"E" : @"处理中",
		@"F" : @"",
		@"G" : @"审核中",
		@"H" : @"审核未通过",
		@"I" : @"合同未确认",
		@"J" : @"合同已签署",
		@"K" : @"已取消",
		@"L" : @"资料重传",
		@"M" : @"正常",
		@"N" : @"已退货"
	};
	
	return dic[key];
}

@end
