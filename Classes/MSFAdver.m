//
//	MSFAdver.m
//	Cash
//
//	Created by xbm on 15/5/14.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFAdver.h"

@implementation MSFAdver

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{@"desc" : @"description"};
}

+ (NSValueTransformer *)imageJSONTransformer {
	return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MSFAdverImage.class];
}

@end
