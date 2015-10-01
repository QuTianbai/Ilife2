//
//  MSFCirculateCashModel.m
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFCirculateCashModel.h"
#import "MSFCirculateCashInfoModel.h"

@implementation MSFCirculateCashModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
	return @{@"mydata":@"data"};
}

+ (NSValueTransformer *)mydataJSONTransformer {
	return [MTLValueTransformer mtl_JSONDictionaryTransformerWithModelClass:MSFCirculateCashInfoModel.class];
}

@end
