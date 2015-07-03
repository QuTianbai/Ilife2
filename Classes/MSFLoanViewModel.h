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
};

@interface MSFLoanViewModel : RVMViewModel

@property(nonatomic,strong,readonly) NSString *title;
@property(nonatomic,strong,readonly) NSString *status;
@property(nonatomic,strong,readonly) NSString *applyDate;
@property(nonatomic,strong,readonly) NSString *repaidAmount;
@property(nonatomic,strong,readonly) NSString *totalAmount;
@property(nonatomic,strong,readonly) NSString *mothlyRepaymentAmount;
@property(nonatomic,strong,readonly) NSString *totalInstallments;
@property(nonatomic,strong,readonly) NSString *currentInstallment;

- (instancetype)initWithModel:(id)model;

@end
