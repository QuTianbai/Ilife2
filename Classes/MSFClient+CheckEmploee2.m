//
//  MSFClient+CheckEmploee2.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+CheckEmploee2.h"
#import "MSFMarkets.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFUser.h"

@implementation MSFClient (CheckEmploee2)

- (RACSignal *)fetchCheckEmploeeWithProductCode:(NSString *)code {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"loan/product" parameters:@{
		@"productCode": code,
		@"uniqueId": self.user.uniqueId
	}];
	
	return [[self enqueueRequest:request resultClass:MSFMarkets.class] msf_parsedResults];
}

@end
