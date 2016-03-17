//
//  MSFMyOrderListViewModel.h
//  Finance
//
//  Created by xbm on 16/3/2.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import <ReactiveViewModel/ReactiveViewModel.h>
#import <UIKit/UIKit.h>

@interface MSFMyOrderListViewModel : RVMViewModel

//贷款类型
@property (nonatomic, readonly) UIImage *contractImg;
@property (nonatomic, readonly) NSString *contractTitile;
@property (nonatomic, readonly) NSString *contractSubTitile;
@property (nonatomic, readonly) NSString *applyType;
@property (nonatomic, readonly) NSString *applyTime;
@property (nonatomic, readonly) NSString *appLmt;
@property (nonatomic, readonly) NSString *loanTerm;
@property (nonatomic, readonly) NSString *status;
@property (nonatomic, readonly) NSString *appNo;
@property (nonatomic, readonly) NSString *loanFixedAmt;
@property (nonatomic, readonly) NSString *loanPurpose;
@property (nonatomic, readonly) NSString *bankCardNo;
@property (nonatomic, readonly) NSString *jionLifeInsurance;
@property (nonatomic, readonly) NSString *monthMoney;

- (instancetype)initWithServices:(id)services model:(id)model;

@end
