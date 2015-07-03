//
//  MSFAccordToNperList.m
//  Cash
//  根据金额获取期数列表
//  Created by xutian on 15/5/16.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFAccordToNperLists.h"

@implementation MSFAccordToNperLists
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
    @"installmentID": @"installment_id",
    @"nper": @"issue",
    };
}

@end
