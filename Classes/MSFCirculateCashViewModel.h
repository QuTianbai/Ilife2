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

enum SHOWTYPES {
	APPLYCASH,
	APPLYANGCIRCULATECASH,
	ALLPYANDSOCIALCASH
};

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

@property (nonatomic, copy) NSString *contractStatus;

@property (nonatomic, assign) NSInteger status;//用户显示产品状态，1马上贷 2马上贷+社保贷 3马上贷+循环贷

@property (nonatomic, assign) id<MSFViewModelServices>services;

@property (nonatomic, strong) RACCommand *executeCirculateCommand;

- (instancetype)initWithServices:(id<MSFViewModelServices>)services;

- (RACSignal *)fetchBankCardListSignal;

@end
