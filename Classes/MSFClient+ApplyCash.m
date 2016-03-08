//
//	MSFClient+ApplyCash.m
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient+ApplyCash.h"
#import "MSFApplicationResponse.h"
#import "RACSignal+MSFClientAdditions.h"
#import "MSFApplicationForms.h"
#import <objc/runtime.h>

@implementation MSFClient (ApplyCash)

- (RACSignal *)fetchApplyCash {
	return RACSignal.empty;
}

- (RACSignal *)applyInfoSubmit1:(id)model {
	return RACSignal.empty;
}

@end
