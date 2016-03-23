//
//  MSFCheckAllowApply.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFCheckAllowApply.h"
#import "MSFApplyCashInfo.h"

@implementation MSFCheckAllowApply

+ (NSValueTransformer *)dataJSONTransformer {
	return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MSFApplyCashInfo.class];
}

@end
