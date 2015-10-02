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
@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *money;

@property (nonatomic, copy) NSString *applyDate;

@property (nonatomic, copy) NSString *period;

@property (nonatomic, copy) NSString *currentPeriodDate;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *produceType;

/*
 *
 *循环贷字段
*/

@property (nonatomic, copy) NSString *totalLimit;

@property (nonatomic, copy) NSString *usedLimit;

@property (nonatomic, copy) NSString *usableLimit;

@property (nonatomic, copy) NSString *overdueMoney;

@property (nonatomic, copy) NSString *contractExpireDate;

@property (nonatomic, copy) NSString *latestDueMoney;

@property (nonatomic, copy) NSString *latestDueDate;

@property (nonatomic, copy) NSString *totalOverdueMoney;

@property (nonatomic, copy) NSString *contractNo;

@end
