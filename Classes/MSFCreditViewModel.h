//
//  MSFCreditViewModel.h
//  Finance
//
//  Created by Wyc on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"
#import "MSFApplication.h"

@class RACCommand ;

@interface MSFCreditViewModel : RVMViewModel

@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *subtitle;

@property (nonatomic, strong, readonly) NSString *applyNumber;
@property (nonatomic, strong, readonly) NSString *applyAmouts;
@property (nonatomic, strong, readonly) NSString *applyTerms;
@property (nonatomic, strong, readonly) NSString *applyCard;
@property (nonatomic, strong, readonly) NSString *applyReason;

@property (nonatomic, strong, readonly) NSString *monthRepayAmounts;
@property (nonatomic, strong, readonly) NSString *loanMonthes;

@property (nonatomic, strong, readonly) NSArray *photos;
@property (nonatomic, strong, readonly) NSString *groundTitle;
@property (nonatomic, strong, readonly) NSString *groundContent;

@property (nonatomic, assign, readonly) MSFApplicationStatus status;

//申请视图中的按钮
@property (nonatomic, strong, readonly) NSString  *action;
@property (nonatomic, strong, readonly) RACCommand *excuteActionCommand;
@property (nonatomic, strong, readonly) RACCommand *excuteDrawCommand;
@property (nonatomic, strong, readonly) RACCommand *executeRepayCommand;
@property (nonatomic, strong, readonly) RACCommand *executeBillCommand;
@property (nonatomic, weak, readonly) id <MSFViewModelServices>services;

- (instancetype)initWithServices:(id<MSFViewModelServices>)services;

@end
