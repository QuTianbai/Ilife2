//
//  MSFRepayPlayMode.h
//  Finance
//
//  Created by Wyc on 16/3/17.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFObject.h"
#import "MSFViewModelServices.h"
#import <ReactiveViewModel/ReactiveViewModel.h>

@interface MSFRepayPlayMode : MSFObject

@property (nonatomic, copy, readonly) NSString *contractNo;
@property (nonatomic, copy, readonly) NSString *contractStatus;
@property (nonatomic, assign, readonly) double  latestDueMoney;
@property (nonatomic, copy, readonly) NSString *latestDueDate;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, assign, readonly) double *appLmt;
@property (nonatomic, assign, readonly) int loanTerm;
@property (nonatomic, copy, readonly) NSString *loanCurrTerm;
@property (nonatomic, copy, readonly) NSString *loanExpireDate;

- (instancetype)initWithServices:(id <MSFViewModelServices>)service contractNo:(NSString *)contractNo;

@end
