//
//	MSFClient+Repayment.m
//	Cash
//
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+Repayment.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFRepayMent.h"

@implementation MSFClient (Repayment)

- (RACSignal *)fetchRepayment {
	NSURLRequest *requset = [self requestWithMethod:@"GET" path:@"repayment" parameters:nil];
	
	return [[self enqueueRequest:requset resultClass:MSFRepayMent.class] msf_parsedResults];
}

@end
