//
//  MSFCirculateCashModel.h
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFCirculateCashModel : MSFObject
/*
 *
 *马上贷字段
 */
@property (nonatomic, copy) NSString *type;//合同/申请单，APPLY确认合同（applyStatus）不是得话contractStatus

@property (nonatomic, copy) NSString *money;//申请单：申请金额 合同还款中为 ：每月应还款额  逾期状态：所有未还金额

@property (nonatomic, copy) NSString *applyDate;//申请日期

@property (nonatomic, copy) NSString *period;//申请期数

@property (nonatomic, copy) NSString *currentPeriodDate;//当前期截止日期

@property (nonatomic, copy) NSString *contractStatus;

@property (nonatomic, copy) NSString *applyStatus;//状态：申请中，还款中，已逾期，

@property (nonatomic, copy) NSString *produceType;//产品类型   循环贷/马上贷

@property (nonatomic, copy) NSString *applyNo;//申请单号

/*
 *
 *循环贷字段
*/

@property (nonatomic, copy) NSString *totalLimit;//总额度

@property (nonatomic, copy) NSString *usedLimit;//已用额度

@property (nonatomic, copy) NSString *usableLimit;//可用额度

@property (nonatomic, copy) NSString *overdueMoney;//已逾期金额

@property (nonatomic, copy) NSString *contractExpireDate;//合同到期日

@property (nonatomic, copy) NSString *latestDueMoney;//最近应还款额

@property (nonatomic, copy) NSString *latestDueDate;//最近还款日

@property (nonatomic, copy) NSString *totalOverdueMoney;//总欠款

@property (nonatomic, copy) NSString *contractNo;//合同号

@end
