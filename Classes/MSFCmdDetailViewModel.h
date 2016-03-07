//
//  MSFCmdDetailViewModel.h
//  Finance
//
//  Created by xbm on 16/3/1.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface MSFCmdDetailViewModel : RVMViewModel

@property (nonatomic, copy, readonly) NSString *cmdtyName;
@property (nonatomic, copy, readonly) NSString *cmdtyPrice;
@property (nonatomic, copy, readonly) NSString *orderTime;

- (instancetype)initWithModel:(id)model;

@end
