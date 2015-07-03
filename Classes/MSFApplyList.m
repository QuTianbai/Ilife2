//
//  MSFApplyList.m
//  Cash
//
//  Created by xbm on 15/5/16.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFApplyList.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"

@implementation MSFApplyList

+ (NSValueTransformer *)apply_timeJSONTransformer {
  return [MTLValueTransformer transformerWithBlock:^id(NSString *string) {
    return [NSDateFormatter msf_dateFromString:string];
  }];
}

+ (NSValueTransformer *)total_installmentsJSONTransformer {
  return [MTLValueTransformer transformerWithBlock:^id(id object) {
    return [object isKindOfClass:NSNumber.class]?[object stringValue]:object;
  }];
}

+ (NSValueTransformer *)current_installmentJSONTransformer {
  return [MTLValueTransformer transformerWithBlock:^id(id object) {
    return [object isKindOfClass:NSNumber.class]?[object stringValue]:object;
  }];
}

@end
