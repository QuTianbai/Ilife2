//
// MSFWalletViewModel.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import "MSFViewModelServices.h"

typedef NS_ENUM(NSUInteger, MSFWalletStatus) {
	MSFWalletNone,        // 未激活的状态
	MSFWalletInReview,    // 审核中
	MSFWalletConfirmation, // 等待合同确认
	MSFWalletResubmit,    // 资料重传
	MSFWalletRelease,     // 放款中
	MSFWalletRejected,    // 审核失败需要重新提交
	MSFWalletActivated,   // 已激活
};

@class RACCommand;

@interface MSFWalletViewModel : RVMViewModel


@property (nonatomic, strong, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSString *subtitle;

@property (nonatomic, strong, readonly) NSString *repayAmounts;
@property (nonatomic, strong, readonly) NSString *repayDates;

@property (nonatomic, strong, readonly) NSArray *photos;

@property (nonatomic, assign, readonly) MSFWalletStatus status;

@property (nonatomic, strong, readonly) NSString *totalAmounts;
@property (nonatomic, strong, readonly) NSString *validAmounts;
@property (nonatomic, strong, readonly) NSString *usedAmounts;
@property (nonatomic, strong, readonly) NSString *loanRates;
@property (nonatomic, strong, readonly) NSString *repayDate;

// 申请视图中的按钮名称
@property (nonatomic, strong, readonly) NSString *action;

@property (nonatomic, strong, readonly) RACCommand *excuteActionCommand;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services;

@end
