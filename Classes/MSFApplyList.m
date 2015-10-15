//
//	MSFApplyList.m
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFApplyList.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

@implementation MSFApplyList

+ (NSValueTransformer *)current_installmentJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(id object) {
		return [object isKindOfClass:NSNumber.class]?[object stringValue]:object;
	}];
}

+ (NSValueTransformer *)statusStringJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(id object) {
		NSDictionary *formatter = @{@"A" : @"",
																@"B" : @"审核中",
																@"C" : @"确认合同",
																@"D" : @"审核未通过",
																@"E" : @"待放款",
																@"F" : @"还款中",
																@"G" : @"已取消",
																@"H" : @"已还款",
																@"I" : @"已逾期",
																@"J" : @"已到期"};
		return formatter[object];
	}];
}

@end
