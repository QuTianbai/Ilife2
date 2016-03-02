//
//	MSFClient+ApplyInfo.h
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFApplicationForms;

@interface MSFClient (ApplyInfo)

// 获取用户申请表个人资料 MSFApplicationForms
- (RACSignal *)fetchApplyInfo __deprecated_msg("Use fetch User info");

// 保存用户申请表个人资料
- (RACSignal *)submitUserInfo:(MSFApplicationForms *)model infoType:(int)type __deprecated;

@end
