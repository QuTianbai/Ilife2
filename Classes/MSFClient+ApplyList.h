//
//	MSFClient+MSFApplyList.h
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@class MSFApplyList;

@interface MSFClient (ApplyList)

- (RACSignal *)fetchSpicyApplyList:(NSString *)type;
- (RACSignal *)fetchRepayURLWithAppliList:(MSFApplyList *)applylist;

// 获取最近一笔贷款信息
// 判断用户的信用钱包是否激活
- (RACSignal *)fetchRecentApplicaiton:(NSString *)type;

@end
