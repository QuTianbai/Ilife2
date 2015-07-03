//
//  MSFMonths.m
//  Cash
//
//  Created by xbm on 15/5/27.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFMonths.h"

@implementation MSFMonths

+ (NSValueTransformer *)productIdJSONTransfromer {
  return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *num) {
    return num.stringValue;
  } reverseBlock:^id(NSString *str) {
    if (str==nil) {
      return [NSDecimalNumber decimalNumberWithString:str];
    }
    
    return nil;
  }];
}

+ (NSValueTransformer *)periodJSONTransfromer {
  return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(NSNumber *num) {
    return num.stringValue;
  } reverseBlock:^id(NSString *str) {
    if (str==nil) {
      return [NSDecimalNumber decimalNumberWithString:str];
    }
    
    return nil;
  }];
}

- (BOOL)validatePeriod:(id *)period error:(NSError **)error {
  if ([*period isKindOfClass:NSString.class]) {
    return YES;
  }
  else if ([*period isKindOfClass:NSNumber.class]) {
    *period = [*period stringValue];
    
    return YES;
  }
  
  return *period == nil;
}

- (BOOL)validateProductId:(id *)productId error:(NSError **)error {
  if ([*productId isKindOfClass:NSString.class]) {
    return YES;
  }
  else if ([*productId isKindOfClass:NSNumber.class]) {
    *productId = [*productId stringValue];
    
    return YES;
  }
  
  return *productId == nil;
}

#pragma mark - MSFSelectionItem

- (NSString *)title {
  return [self.period stringByAppendingString:@"期"];
}

- (NSString *)subtitle {
  return @"";
  //return self.productName;
}

@end
