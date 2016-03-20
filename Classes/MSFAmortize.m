//
//  MSFMarkets.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFAmortize.h"
#import "MSFOrganize.h"

@implementation MSFAmortize

+ (NSValueTransformer *)teamsJSONTransformer {
	return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFOrganize.class];
}

@end
