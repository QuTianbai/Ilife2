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
		NSDictionary *formatter = @{@"U" : @"正在处理",
																@"R" : @"拒绝",
																@"A" : @"通过",
																@"C" : @"激活前取消",
																@"N" : @"签署",
																@"J" : @"放弃"};
		return formatter[object];
	}];
}

@end
