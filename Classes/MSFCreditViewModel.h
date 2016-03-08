//
//  MSFCreditViewModel.h
//  Finance
//
//  Created by Wyc on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

typedef NS_ENUM(NSUInteger, MSFCreditStatus) {
    MSFCreditNone,         //未激活状态
    NSFCreditInReview,     //审核中
    NSFCreditConfirmation, //等待合同确认
    MSFCreditResubmit,     //资料重传
    MSFCreditRelease,     //放款中
    MSFCreditRejected,  //审核失败需要重新提交
    MSFCreditActivated, //已激活
    
};

@class RACCommand ;

@interface MSFCreditViewModel : RVMViewModel

@property (nonatomic, strong, readonly) NSString  *action;
@property (nonatomic, strong, readonly) RACCommand *excuteActionCommand;
@property (nonatomic, strong, readonly) RACCommand *excuteDrawCommand;
@property (nonatomic, strong, readonly) RACCommand *executeRepayCommand;
@property (nonatomic, strong, readonly) RACCommand *executeBillCommand;

- (instancetype)initWithServices:(id<MSFViewModelServices>)services;

@end
