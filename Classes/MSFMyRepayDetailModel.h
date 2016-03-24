//
//  MSFMyRepayDetailModel.h
//  Finance
//
//  Created by xbm on 16/2/29.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"

@interface MSFMyRepayDetailModel : MSFObject

@property (nonatomic, copy, readonly) NSString *contractNo;
@property (nonatomic, copy, readonly) NSString *latestDueMoney;
@property (nonatomic, copy, readonly) NSString *latestDueDate;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *appLmt;
@property (nonatomic, copy, readonly) NSString *loanTerm;
@property (nonatomic, copy, readonly) NSString *loanCurrTerm;
@property (nonatomic, copy, readonly) NSString *loanExpireDate;
@property (nonatomic, copy, readonly) NSString *totalOverdueMoney;
@property (nonatomic, copy, readonly) NSString *interest;
@property (nonatomic, copy, readonly) NSString *applyDate;
@property (nonatomic, strong, readonly) NSArray *cmdtyList;
@property (nonatomic, strong, readonly) NSArray *withdrawList;
@property (nonatomic, copy, readwrite) NSString *contractStatus;
@property (nonatomic, copy, readwrite) NSString *totalCurrTerm;//总欠款期数
@property (nonatomic, copy, readwrite) NSString *systemDate;//系统时间

@end
