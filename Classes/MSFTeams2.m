//
//  MSFTeams2.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFTeams2.h"
#import "MSFTeam.h"

@implementation MSFTeams2

+ (NSValueTransformer *)teamJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFTeam.class];
}

@end
