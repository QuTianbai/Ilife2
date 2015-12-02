//
//	MSFClient+MSFApplyInfo.h
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFApplicationForms;

@interface MSFClient (MSFApplyInfo)

// 获取用户申请表个人资料 MSFApplicationForms
- (RACSignal *)fetchApplyInfo;

// 保存用户申请表个人资料
- (RACSignal *)submitUserInfo:(MSFApplicationForms *)model infoType:(int)type;

- (RACSignal *)fetchApplyInfoSubmit1:(NSString *)moneyNum months:(NSString *)months moneyUsed:(NSString *)moneyUsed isInsurancePlane:(NSString *)InsurancePlane applyStatus:(NSString *)status loanID:(NSString *)loanID __deprecated;

@end
