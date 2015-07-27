//
//	MSFClient+MSFApplyInfo.m
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+MSFApplyInfo.h"
#import "MSFApplicationForms.h"
#import "RACSignal+MSFClientAdditions.h"

@implementation MSFClient (MSFApplyInfo)

- (RACSignal *)fetchApplyInfo {
	NSURLRequest *request = [self requestWithMethod:@"GET" path:@"loans/spec" parameters:nil];
	return [[self enqueueRequest:request resultClass:MSFApplicationForms.class] msf_parsedResults];
}

- (RACSignal *)fetchApplyInfoSubmit1:(NSString *)moneyNum months:(NSString *)months moneyUsed:(NSString *)moneyUsed isInsurancePlane:(NSString *)InsurancePlane applyStatus:(NSString *)status loanID:(NSString *)loanID {
	return nil;
}

@end
