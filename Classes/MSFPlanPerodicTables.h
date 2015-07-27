//
//	MSFPlanPerodicTable.h
//	Cash
//	计划期列表
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFPlanPerodicTables : MSFObject

@property (nonatomic, copy, readonly) NSString *contractNum;
@property (nonatomic, copy, readonly) NSString *repaymentTime;
@property (nonatomic, assign, readonly) double	 repaymentAmount;
@property (nonatomic, copy, readonly) NSString *amountType;
@property (nonatomic, copy, readonly) NSString *contractStatus;

@end
