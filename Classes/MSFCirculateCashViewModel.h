//
//  MSFCirculateCashViewModel.h
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class RACCommand;
@class MSFCirculateCashModel;

@interface MSFCirculateCashViewModel : RVMViewModel

@property (nonatomic, strong) MSFCirculateCashModel *infoModel;

@property (nonatomic, copy) NSString *totalLimit;

@property (nonatomic, copy) NSString *usedLimit;

@property (nonatomic, copy) NSString *usableLimit;

@property (nonatomic, copy) NSString *overdueMoney;

@property (nonatomic, copy) NSString *contractExpireDate;

@property (nonatomic, copy) NSString *latestDueMoney;

@property (nonatomic, copy) NSString *latestDueDate;

@property (nonatomic, copy) NSString *totalOverdueMoney;

@property (nonatomic, copy) NSString *contractNo;

@property (nonatomic, assign) id<MSFViewModelServices>services;

@property (nonatomic, strong) RACCommand *executeCirculateCommand;

- (instancetype)initWithServices:(id<MSFViewModelServices>)services;

- (RACSignal *)fetchBankCardListSignal;

@end
