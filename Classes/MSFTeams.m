//
//	MSFTeam.m
//	Cash
//
//	Created by xbm on 15/5/20.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFTeams.h"
#import "MSFProduct.h"

@implementation MSFTeams

+ (NSValueTransformer *)teamJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFProduct.class];
}

@end
