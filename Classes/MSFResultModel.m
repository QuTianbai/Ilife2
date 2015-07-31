//
//  MSFResultModel.m
//  Finance
//
//  Created by xbm on 15/7/31.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFResultModel.h"
#import "MSFAddressInfo.h"

@implementation MSFResultModel

+ (NSValueTransformer *)addressComponentJSONTransformer {
  return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MSFAddressInfo.class];
}

@end
