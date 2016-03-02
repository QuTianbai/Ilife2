//
//  MSFMyOrderListViewModel.h
//  Finance
//
//  Created by xbm on 16/3/2.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface MSFMyOrderListViewModel : RVMViewModel

//贷款类型
@property (nonatomic, readonly) NSString *applyType;

- (instancetype)initWithModel:(id)model;

@end
