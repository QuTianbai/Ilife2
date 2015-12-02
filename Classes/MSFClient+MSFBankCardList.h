//
//  MSFClient+MSFBankCardList.h
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFBankCardList)

// 获取用户银行卡列表
//
// Returns a singal which sends zero or more MSFBankCardListModel objects
- (RACSignal *)fetchBankCardList;

@end
