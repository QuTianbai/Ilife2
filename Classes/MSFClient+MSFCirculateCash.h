//
//  MSFClient+MSFCirculateCash.h
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFCirculateCash)

- (RACSignal *)fetchCirculateCash;

@end
