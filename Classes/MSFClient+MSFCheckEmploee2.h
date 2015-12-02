//
//  MSFClient+MSFCheckEmploee2.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFCheckEmploee2)

// 获取马上贷产品信息
//
// code - 马上贷产品群代码
//
// Returns a signal which sends a MSFMarkets
- (RACSignal *)fetchCheckEmploeeWithProductCode:(NSString *)code;

@end
