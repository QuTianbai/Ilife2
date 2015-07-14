//
//	MSFPhotoStatus.m
//	Cash
//
//	Created by xbm on 15/6/3.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFPhotoStatus.h"
#import "MSFPhoto.h"

@implementation MSFPhotoStatus

+ (NSValueTransformer *)id_photoJSONTransformer {
	return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MSFPhoto.class];
}

+ (NSValueTransformer *)owner_photoJSONTransformer {
	return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MSFPhoto.class];
}

@end
