//
//  MSFClient+MSFCheckEmploee.m
//  Cash
//
//  Created by xbm on 15/5/20.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFCheckEmploee.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFMarket.h"

@implementation MSFClient (MSFCheckEmploee)

- (RACSignal *)fetchCheckEmployee {
//  NSURL *URL = [[NSBundle mainBundle] URLForResource:@"products" withExtension:@"json"];
//  NSData *data = [NSData dataWithContentsOfURL:URL];
//  NSDictionary *representation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
//  return [RACSignal return:[MTLJSONAdapter modelOfClass:[MSFCheckEmployee class] fromJSONDictionary:representation error:nil]];
  return [[self enqueueUserRequestWithMethod:@"GET" relativePath:@"/check_employee" parameters:nil resultClass:MSFMarket.class] msf_parsedResults];
}

@end
