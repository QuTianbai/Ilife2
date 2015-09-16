//
// MSFRepaymentSchedulesViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@class MSFRepaymentSchedules;

@interface MSFRepaymentSchedulesViewModel : RVMViewModel

@property (nonatomic, readonly) MSFRepaymentSchedules *model;
@property (nonatomic, readonly) NSString *repaymentNumber;
@property (nonatomic, readonly) NSString *status;
@property (nonatomic, readonly) double amount;
@property (nonatomic, readonly) NSString *date;

- (instancetype)initWithModel:(id)model;

@end
