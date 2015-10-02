//
//  MSFBankCardInfoViewModel.h
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@interface MSFBankCardInfoViewModel : RVMViewModel
@property (nonatomic, copy, readonly) NSString *bankCardId;
@property (nonatomic, copy, readonly) NSString *bankCardNo;
@property (nonatomic, copy, readonly) NSString *bankCardType;
@property (nonatomic, copy, readonly) NSString *bankName;
@property (nonatomic, copy, readonly) NSString *bankBranchCityCode;
@property (nonatomic, copy, readonly) NSString *bankBranchProvinceCode;
@property (nonatomic, copy, readonly) NSString *isMaster;

- (instancetype)initWithServices:(id<MSFViewModelServices>)servers;

@end
