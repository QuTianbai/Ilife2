//
//	MSFClient+RepaymentSchedule.h
//	Cash
//
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"

@interface MSFClient (RepaymentSchedules)

//
//请求马上贷还款计划
//
// Returns a signal will send a instance of <MSFRepaymentSchedules>
- (RACSignal *)fetchRepaymentSchedules;

//
//请求社保贷还款计划
//
// Returns a signal will send a instance of <MSFRepaymentSchedules>
- (RACSignal *)fetchCircleRepaymentSchedules;

@end
