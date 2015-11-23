//
//  MSFClient+MSFProductList.h
//  Finance
//
//  Created by xbm on 15/11/23.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFProductList)

- (RACSignal *)fetchProductList;

@end
