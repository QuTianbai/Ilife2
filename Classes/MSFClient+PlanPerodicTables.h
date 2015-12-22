//
//	MSFClient+PlanPerodicTable.h
//	Cash
//
//	Created by xutian on 15/5/15.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"
#import "MSFRepaymentSchedules.h"

@interface MSFClient (PlanPerodicTables)

- (RACSignal *)fetchPlanPerodicTables:(MSFRepaymentSchedules *)planPerodicTablesID;

@end
