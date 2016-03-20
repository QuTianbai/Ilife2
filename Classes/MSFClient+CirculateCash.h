//
//  MSFClient+CirculateCash.h
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (CirculateCash)

//type。@"1"：贷款申请 @"2"：额度显示 nil：首页申请
- (RACSignal *)fetchCirculateCash:(NSString *)type;

@end
