//
//  MSFMarkets.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFMarkets.h"
#import "MSFTeams2.h"

@implementation MSFMarkets

+ (NSValueTransformer *)teamsJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFTeams2.class];
}


@end
