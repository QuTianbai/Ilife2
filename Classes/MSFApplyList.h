//
//	MSFApplyList.h
//	Cash
//
//	Created by xbm on 15/5/16.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFApplyList : MSFObject

@property (nonatomic, copy, readonly) NSString *productCd;//产品编号
@property (nonatomic, copy, readonly) NSString *applyTime;//申请时间
@property (nonatomic, copy, readonly) NSString *appLmt;//申请金额
@property (nonatomic, copy, readonly) NSString *loanTerm;//总期数
@property (nonatomic, copy ,readonly) NSString *statusString;//状态描述
@property (nonatomic, copy ,readonly) NSString *status;//状态描述
@property (nonatomic, copy, readonly) NSString *appNo;//申请单号
@property (nonatomic, copy, readonly) NSString *type; //类型
@property (nonatomic, copy ,readonly) NSString *typeString;//类型描述
@property (nonatomic, copy, readonly) NSString *loanFixedAmt;//月还款额
@property (nonatomic, copy, readonly) NSString *failInfo;//失败原因
@property (nonatomic, copy, readonly) NSString *loanPurpose;//贷款用途
@property (nonatomic, copy, readonly) NSString *bankCardNo;//银行卡

@end
