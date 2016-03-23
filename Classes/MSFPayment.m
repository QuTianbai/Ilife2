//
// MSFPayment.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFPayment.h"

@implementation MSFPayment

+ (NSValueTransformer *)receiveTimeJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *number) {
        return [number isKindOfClass:[NSNumber class]]?number.stringValue:number;
    } reverseBlock:^id(NSString *str) {
        return str;
    }];
}

@end
