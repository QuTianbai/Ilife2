//
// MSFWalletViewModel.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"
#import "MSFApplication.h"

@class RACCommand;

@interface MSFWalletViewModel : RVMViewModel


@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *subtitle;

@property (nonatomic, strong, readonly) NSString *repayAmounts;
@property (nonatomic, strong, readonly) NSString *repayDates;

@property (nonatomic, strong, readonly) NSArray *photos;
@property (nonatomic, strong, readonly) NSString *groundTitle __deprecated;
@property (nonatomic, strong, readonly) NSString *groundContent;

@property (nonatomic, assign, readonly) MSFApplicationStatus status;

@property (nonatomic, strong, readonly) NSString *totalAmounts;
@property (nonatomic, strong, readonly) NSString *validAmounts;
@property (nonatomic, strong, readonly) NSString *usedAmounts;
@property (nonatomic, strong, readonly) NSString *loanRates;
@property (nonatomic, strong, readonly) NSString *repayDate;

// 申请视图中的按钮名称
@property (nonatomic, strong, readonly) NSString *action;

@property (nonatomic, strong, readonly) RACCommand *excuteActionCommand;
@property (nonatomic, strong, readonly) RACCommand *executeDrawCommand;
@property (nonatomic, strong, readonly) RACCommand *executeRepayCommand;
@property (nonatomic, strong, readonly) RACCommand *executeBillsCommand;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
