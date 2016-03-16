//
//  MSFClient+MSFCheckAllowApply.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+CheckAllowApply.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFCheckAllowApply.h"
#import "MSFUser.h"

@implementation MSFClient (CheckAllowApply)

- (RACSignal *)fetchCheckAllowApply {
	NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:@"loan/allow" parameters:nil];
    request.allHTTPHeaderFields = [request.allHTTPHeaderFields mtl_dictionaryByAddingEntriesFromDictionary:@{
                                                                                                             @"uniqueId":self.user.uniqueId
                                                                                                             }];
	return [[self enqueueRequest:request resultClass:MSFCheckAllowApply.class] msf_parsedResults];
}

@end
