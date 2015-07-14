//
//  MSFClient+MSFApplyList.h
//  Cash
//
//  Created by xbm on 15/5/16.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFApplyList;

@interface MSFClient (ApplyList)

- (RACSignal *)fetchApplyList;
- (RACSignal *)fetchRepayURLWithAppliList:(MSFApplyList *)applylist;

@end
