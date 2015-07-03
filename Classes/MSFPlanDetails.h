//
//  MSFPlanDetails.h
//  Cash
//  计划详情
//  Created by xutian on 15/5/15.
//  Copyright (c) 2015年 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

@interface MSFPlanDetails : MSFObject

@property(nonatomic,copy,readonly) NSString *planID;
@property(nonatomic,copy,readonly) NSString *time;
@property(nonatomic,assign,readonly) double repaymentAmount;
@property(nonatomic,assign,readonly) double interest;
@property(nonatomic,assign,readonly) double serviceCharge;
@property(nonatomic,assign,readonly) double totalMoney;

@end
