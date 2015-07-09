//
//  MSFCheckEmployee.m
//  Cash
//
//  Created by xbm on 15/5/20.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFMarket.h"
#import "MSFTeams.h"

@implementation MSFMarket

+ (NSValueTransformer *)teamsJSONTransformer {
  return [MTLValueTransformer mtl_JSONArrayTransformerWithModelClass:MSFTeams.class];
}

@end
