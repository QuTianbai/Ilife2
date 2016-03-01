//
//  MSFWithDrawViewModel.h
//  Finance
//
//  Created by xbm on 16/3/1.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>

@interface MSFWithDrawViewModel : RVMViewModel

@property (nonatomic, copy, readonly) NSString *bankCode;
@property (nonatomic, copy, readonly) NSString *bankName;
@property (nonatomic, copy, readonly) NSString *bankCardNo;
@property (nonatomic, copy, readonly) NSString *withdrawDate;
@property (nonatomic, copy, readonly) NSString *withdrawMoney;

- (instancetype)initWithModel:(id)model;

@end
