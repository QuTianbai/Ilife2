//
//  MSFClient+MSFApplyList.h
//  Cash
//
//  Created by xbm on 15/5/16.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFApplyList)

- (RACSignal *)fetchApplyList;

@end
