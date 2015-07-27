//
//	MSFRepaymentSchedule.h
//	Cash
//	计划列表
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFRepaymentSchedules : MSFObject

@property (nonatomic, copy, readonly) NSString *contractNum;
@property (nonatomic, copy, readonly) NSString *contractStatus;
@property (nonatomic, copy, readonly) NSString *repaymentTime;
@property (nonatomic, assign, readonly) double repaymentTotalAmount;

@end
