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
	
		return @{
						 @"adID": @"ad_id",
						 @"title": @"title",
						 @"type": @"type",
						 @"adDescription": @"description",
						 @"adURL": @"url",
						 @"imgURL": @"image",
						 @"imageName": @"imagename",
						 };
}

+ (NSValueTransformer *)adURLJSONTransformer {
	return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)imgURLJSONTransformer {
	return [MTLValueTransformer transformerWithBlock:^id(NSDictionary *image) {
				return [NSURL URLWithString:image[@"url"]];
		}];
}

+ (NSValueTransformer *)typeJSONTransformer {
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *num) {
				return num.stringValue;
		} reverseBlock:^id(NSString *str) {
				if (str==nil) {
						return [NSDecimalNumber decimalNumberWithString:str];
				}
			
				return nil;
		}];
}

@end
