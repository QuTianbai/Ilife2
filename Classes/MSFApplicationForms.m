//
//  MSFApplyInfo.m
//  Cash
//
//  Created by xbm on 15/5/16.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFApplicationForms.h"
#import "MSFPhotoStatus.h"

@implementation MSFApplicationForms

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{@"loanId":@"id"};
}

+ (NSValueTransformer *)whitePhotoJSONTransformer {
  return [MTLValueTransformer reversibleTransformerWithForwardBlock:^id(id photo) {
    if (![photo isKindOfClass:NSDictionary.class]) {
      return nil;
    }
    
    return [MTLJSONAdapter modelOfClass:MSFPhotoStatus.class fromJSONDictionary:photo error:nil];
  } reverseBlock:^id(MSFPhotoStatus *whitePhoto) {
    return whitePhoto.dictionaryValue;
  }];
}

@end
