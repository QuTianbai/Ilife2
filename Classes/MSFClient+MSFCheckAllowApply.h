//
//  MSFClient+MSFCheckAllowApply.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (MSFCheckAllowApply)

// 通过接口判断是否允许贷款
//
// Returns a signal which will send a MSFCheckAllowApply
- (RACSignal *)fetchCheckAllowApply;

@end
