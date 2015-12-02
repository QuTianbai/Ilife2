//
//  MSFClient+MSFSubmitAppyCash.h
//  Finance
//
//  Created by xbm on 15/10/3.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFClient.h"

@class MSFApplyCashModel;

@interface MSFClient (MSFSubmitAppyCash)

// 提交马上贷申请资料
//
// infoModel       - 马上贷申请资料清单
// AccessoryInfoVO -  附件资料清单 NSArray <NSDictionary>
// status          - 提交的状态 0 保存到服务器 1 确认提交
//
// Returns a signal which will send a MSFSubmitApplyModel, use to fetch applicaionNo.
- (RACSignal *)fetchSubmitWithApplyVO:(MSFApplyCashModel *)infoModel AndAcessory:(id)AccessoryInfoVO Andstatus:(NSString *)status;

@end
