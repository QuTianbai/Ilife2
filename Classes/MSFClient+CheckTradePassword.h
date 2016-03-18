//
//  MSFClient+CheckTradePassword.h
//  Finance
//
//  Created by xbm on 15/9/30.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (CheckTradePassword)

// 调用API获取用户的交易密码是否设置
//
// Returns a signal which sends a MSFCheckHasTradePasswordModel
- (RACSignal *)fetchCheckTradePassword;

@end
