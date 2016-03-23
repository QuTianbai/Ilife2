//
//  MSFMyOrderCmdViewModel.h
//  Finance
//
//  Created by xbm on 16/3/4.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface MSFMyOrderCmdViewModel : RVMViewModel

@property (nonatomic, copy, readonly) NSString *catId;
@property (nonatomic, copy, readonly) NSString *cmdtyId;
@property (nonatomic, copy, readonly) NSString *brandName;
@property (nonatomic, copy, readonly) NSString *cmdtyName;
@property (nonatomic, copy, readonly) NSString *pcsCount;
@property (nonatomic, copy, readonly) NSString *cmdtyPrice;

- (instancetype)initWithModel:(id)model;

@end
