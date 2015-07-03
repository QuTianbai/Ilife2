//
//  MSFClient+MSFCheckEmploee.h
//  Cash
//
//  Created by xbm on 15/5/20.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFCheckEmploee)

- (RACSignal *)fetchCheckEmployee;

@end
