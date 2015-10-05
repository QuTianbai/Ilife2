//
//  MSFApplyCashInfo.h
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFApplyCashInfo : MSFObject
//申请时间
@property (nonatomic, copy) NSString *applyTime;
//申请金额
@property (nonatomic, copy) NSString *appLmt;
//期数
@property (nonatomic, copy) NSString *loanTerm;
//状态
@property (nonatomic, copy) NSString *status;//申请中，还款中，已逾期
//申请单号
@property (nonatomic, copy) NSString *appNo;

@end
