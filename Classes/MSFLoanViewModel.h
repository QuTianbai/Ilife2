//
// MSFLoanViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

// 1：申请中，2：申请成功，3：申请失败，4：还款中，5：取消，6：已完结，7：已逾期
typedef NS_ENUM(NSUInteger, MSFLoanStatus) {
	MSFLoanStatusNone,
	MSFLoanStatusAppling,
	MSFLoanStatusSuccess,
	MSFLoanStatusFailed,
	MSFLoanStatusRepayment,
	MSFLoanStatusCancel,
	MSFLoanStatusFinished,
	MSFLoanStatusExpired,
	MSFLoanStatusExpectedSuccess,
	MSFLoanStatusLoan,
};

@interface MSFLoanViewModel : RVMViewModel

// 标题
@property (nonatomic, strong, readonly) NSString *title;

// 状态,字符串描述	例 `审核通过`
@property (nonatomic, strong, readonly) NSString *status;

// 申请是时间 `2015-07-14`
@property (nonatomic, strong, readonly) NSString *applyDate;

// 还款总额 `¥1000.00`
@property (nonatomic, strong, readonly) NSString *repaidAmount;

// 申请总额 `¥1000.00`
@property (nonatomic, strong, readonly) NSString *totalAmount;

// 每月还款总额 `¥1000.00`
@property (nonatomic, strong, readonly) NSString *mothlyRepaymentAmount;

// 总期数
@property (nonatomic, strong, readonly) NSString *totalInstallments;

// 当前进行到的期数
@property (nonatomic, strong, readonly) NSString *currentInstallment;

- (instancetype)initWithModel:(id)model;

@end
