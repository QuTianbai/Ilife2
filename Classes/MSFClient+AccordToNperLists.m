//
//  MSFClient+AccordToNperLists.m
//  Cash
//
//  Created by xutian on 15/5/16.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+AccordToNperLists.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFAccordToNperLists.h"

@implementation MSFClient (AccordToNperLists)

- (RACSignal *)fetchAccordToNperLists:(MSFApplyList *)applyListID {
  NSString *amount = [NSString stringWithFormat:@"loans/%@/installments",applyListID.total_amount];
  NSURLRequest *requset = [self requestWithMethod:@"GET" path:amount parameters:nil];
  
  return [[self enqueueRequest:requset resultClass:MSFAccordToNperLists.class] msf_parsedResults];
}

@end
