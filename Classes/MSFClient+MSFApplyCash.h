//
//  MSFClient+MSFApplyCash.h
//  Cash
//
//  Created by xbm on 15/5/16.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFApplyInfo;

@interface MSFClient (MSFApplyCash)

- (RACSignal *)fetchApplyCash;
- (RACSignal *)applyInfoSubmit1:(MSFApplyInfo *)model;

@end
