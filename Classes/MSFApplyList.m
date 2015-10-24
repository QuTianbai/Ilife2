//
//	MSFApplyList.m
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFApplyList.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "NSDictionary+MSFKeyValue.h"

@implementation MSFApplyList

+ (NSValueTransformer *)current_installmentJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(id object) {
		return [object isKindOfClass:NSNumber.class]?[object stringValue]:object;
	}];
}

+ (NSValueTransformer *)statusStringJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(id object) {
		return [NSDictionary statusStringForKey:object];
	}];
}

@end
