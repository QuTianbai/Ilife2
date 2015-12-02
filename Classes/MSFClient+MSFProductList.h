//
//  MSFClient+MSFProductList.h
//  Finance
//
//  Created by xbm on 15/11/23.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFProductList)

// 获取产品列表
//
// Returns a signal will send instance of MSFProductListModel
- (RACSignal *)fetchProductList __deprecated;

@end
