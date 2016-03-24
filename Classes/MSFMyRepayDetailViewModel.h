//
//  MSFMyRepayDetailViewModel.h
//  Finance
//
//  Created by xbm on 16/3/1.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@class RACCommand;

@interface MSFMyRepayDetailViewModel : RVMViewModel
@property (nonatomic, copy, readonly) NSString *contractTitle;
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
@property (nonatomic, strong) NSArray *cmdtyList;
@property (nonatomic, strong, readonly) NSArray *withdrawList;
@property (nonatomic, copy, readonly) NSString *contratStatus;
@property (nonatomic, copy, readonly) NSString *totalCurrTerm;

@property (nonatomic, strong) RACCommand *executeFetchRepayCommand;
@property (nonatomic, strong) RACCommand *executeFetchCommand;
@property (nonatomic, strong) RACCommand *executeFetchRepayPlanCommand;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services type:(NSString *)type contractNO:(NSString *)contractNo loanterm:(NSString *)loanterm;

@end
