//
//	MSFClient+PlanDetails.h
//	Cash
//
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"
#import "MSFRepaymentSchedules.h"

@interface MSFClient (PlanDetails)

- (RACSignal *)fetchPlanDetails:(MSFRepaymentSchedules *)repaymentSchedulesID;

@end
