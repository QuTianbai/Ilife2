//
//	MSFClient+ApplyCash.h
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFApplicationForms;

@interface MSFClient (ApplyCash)

// 获取用户马上贷申请表信息
- (RACSignal *)fetchApplyCash __deprecated;

// 保存/提交用户马上贷申请表
- (RACSignal *)applyInfoSubmit1:(id)model __deprecated;

@end
