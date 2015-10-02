//
//  MSFClient+MSFCheckEmploee2.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient+MSFCheckEmploee2.h"
#import "MSFMarkets.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (MSFCheckEmploee2)

- (RACSignal *)fetchCheckEmploeeWithProductCode:(NSString *)code {
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"markets" ofType:@"json"]]];
	
	//NSURLRequest *request = [self requestWithMethod:@"POST" path:@"loans" parameters:@{@"productCode":code}];
	
	return [[self enqueueRequest:request resultClass:MSFMarkets.class] msf_parsedResults];
}

@end
