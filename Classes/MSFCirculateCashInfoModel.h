//
//  MSFCirculateCashInfoModel.h
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年. All rights reserved.
//

#import "MSFObject.h"

@interface MSFCirculateCashInfoModel : MSFObject

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
