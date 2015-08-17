//
//  MSFRepaymentViewModel.h
//  Finance
//
//  Created by 赵勇 on 8/14/15.
//  Copyright (c) 2015 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"

@interface MSFRepaymentViewModel : RVMViewModel

//表示是否具有还款信息
@property (nonatomic, assign, readonly) BOOL repaymentStatus;

// 标题
@property (nonatomic, strong, readonly) NSString *title;

// 状态,字符串描述	例 `审核通过`
@property (nonatomic, strong, readonly) NSString *status;

// 申请是时间 `2015-07-14`
@property (nonatomic, strong, readonly) NSString *expireDate;

// 还款总额 `¥1000.00`
@property (nonatomic, strong, readonly) NSString *repaidAmount;


- (instancetype)initWithModel:(id)model;

@end
