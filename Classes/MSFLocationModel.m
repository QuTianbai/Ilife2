//
//  MSFLocationModel.m
//  Finance
//
//  Created by xbm on 15/7/30.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFLocationModel.h"
#import "MSFResultModel.h"

@implementation MSFLocationModel

+ (NSValueTransformer *)resultJSONTransformer {
  return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MSFResultModel.class];
}

@end
