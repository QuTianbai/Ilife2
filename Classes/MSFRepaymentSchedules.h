//
//	MSFRepaymentSchedule.h
//	Cash
//	计划列表
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

// 还款计划
@interface MSFRepaymentSchedules : MSFObject

//社保
@property (nonatomic, copy, readonly) NSString *contractNum;
@property (nonatomic, copy, readonly) NSString *contractStatus;
@property (nonatomic, copy, readonly) NSString *repaymentTime;
@property (nonatomic, copy, readonly) NSString *repaymentTotalAmount;

@property (nonatomic, copy, readonly) NSString *contractExpireDate;
@property (nonatomic, copy, readonly) NSString *totalOverdueMoney;
@property (nonatomic, copy, readonly) NSString *overdueMoney;//已逾期金额

//马上贷
@property (nonatomic, copy, readonly) NSString *cashDueMoney;
@property (nonatomic, copy, readonly) NSString *cashDueDate;

@end
