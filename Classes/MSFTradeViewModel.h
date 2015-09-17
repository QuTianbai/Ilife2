//
// MSFTradeViewModel.h
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "RVMViewModel.h"

@interface MSFTradeViewModel : RVMViewModel

@property (nonatomic, copy, readonly) NSString *date;
@property (nonatomic, copy, readonly) NSString *describe;
@property (nonatomic, copy, readonly) NSString *amount;

- (instancetype)initWithModel:(id)model;

@end
