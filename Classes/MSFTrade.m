//
//  MSFTrade.m
//  Cash
//  交易
//  Created by xutian on 15/5/14.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFTrade.h"

@implementation MSFTrade
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
    @"tradeID": @"transaction_id",
    @"tradeDate": @"date",
    @"tradeAmount": @"amount",
    @"tradeDescription": @"description",
    };
}

+ (NSValueTransformer *)dateJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSNumber *num) {
        return num.stringValue;
    } reverseBlock:^ id (NSString *str) {
      if (str == nil) {
       return nil;
      }
        
      return [NSDecimalNumber decimalNumberWithString:str];
    }];
}

@end
