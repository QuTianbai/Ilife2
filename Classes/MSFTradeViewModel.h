//
// MSFTradeViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

// 交易记录
@interface MSFTradeViewModel : RVMViewModel

// 交易时间
@property (nonatomic, copy, readonly) NSString *date;

// 交易描述
@property (nonatomic, copy, readonly) NSString *describe;

// 交易金额
@property (nonatomic, copy, readonly) NSString *amount;

- (instancetype)initWithModel:(id)model;

@end
