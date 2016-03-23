//
//	MSFRepaymentSchedule.h
//	Cash
//	我的还款
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFRepaymentSchedules : MSFObject

//合同编号
@property (nonatomic, copy, readonly) NSString *contractNum;
//还款状态
@property (nonatomic, copy, readonly) NSString *contractStatus;
//最近还款日
@property (nonatomic, copy, readonly) NSString *repaymentTime;
//应还金额
@property (nonatomic, copy, readonly) NSString *repaymentTotalAmount;
//类型
@property (nonatomic, copy, readonly) NSString *contractType;
//贷款金额
@property (nonatomic, assign, readonly) NSString *appLmt;
//贷款期数
@property (nonatomic, assign, readonly) NSString *loanTerm;
//当前期数
@property (nonatomic, copy, readonly) NSString *loanCurrTerm;
//账期
@property (nonatomic, copy, readonly) NSString *loanExpireDate;

@property (nonatomic, copy, readonly) NSString *totalOverdueMoney;

@end
