//
// MSFWallet.h
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFObject.h"

// 信用钱包对象，额度相关信息
@interface MSFWallet : MSFObject

// 总额度
@property (nonatomic, assign, readonly) double totalLimit;

// 已用额度
@property (nonatomic, assign, readonly) double usedLimit;

// 可用刻度
@property (nonatomic, assign, readonly) double usableLimit;

// 已经逾期金额
@property (nonatomic, assign, readonly) double overdueMoney;

// 本期应还款金额
@property (nonatomic, assign, readonly) double latestDueMoney;

// 还款日
@property (nonatomic, copy, readonly) NSString *latestDueDate;

// 总欠款
@property (nonatomic, copy, readonly) NSString *totalOverdueMoney;

// 合同号
@property (nonatomic, copy, readonly) NSString *contractNo;

// 剩余天数
@property (nonatomic, assign, readonly) NSInteger remainingDate;

// 借款日利率
@property (nonatomic, assign, readonly) double feeRate;

@end
