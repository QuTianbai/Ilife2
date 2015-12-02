//
//  MSFConfirmContractModel.h
//  Finance
//
//  Created by xbm on 15/9/3.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

// 合同确认服务器返回信息
@interface MSFConfirmContractModel : MSFObject

@property (nonatomic, copy, readonly) NSString *errorCode;
@property (nonatomic, copy, readonly) NSString *message;

@end
