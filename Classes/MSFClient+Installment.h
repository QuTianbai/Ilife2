//
//	MSFClient+Staging.h
//	Cash
//
//	Created by xutian on 15/5/14.
//	Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFClient.h"
#import "MSFPlanPerodicTables.h"

@interface MSFClient (Installment)

- (RACSignal *)fetchInstallment:(MSFPlanPerodicTables *)planPerodicTables;

@end
