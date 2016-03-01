//
//  MSFMyRepayDetailViewModel.h
//  Finance
//
//  Created by xbm on 16/3/1.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

@interface MSFMyRepayDetailViewModel : RVMViewModel

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

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
