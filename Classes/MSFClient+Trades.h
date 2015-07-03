//
//  MSFClient+Trade.h
//  Cash
//
//  Created by xutian on 15/5/14.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (Trades)

- (RACSignal *)fetchTrades;

@end
