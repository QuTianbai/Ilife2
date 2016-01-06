//
//  MSFAddBankCardVIewModel.h
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"

@class MSFAddressViewModel;
@class MSFBankInfoModel;
@class RACCommand;

@interface MSFAddBankCardVIewModel : RVMViewModel
//忘记交易密码
@property (nonatomic, copy) NSString *TradePassword;
@property (nonatomic, copy) NSString *againTradePWD;
@property (nonatomic, copy) NSString *smsCode;

@property (nonatomic, strong) RACCommand *executeReSetTradePwd;

//添加银行卡
@property (nonatomic, copy) NSString *bankNO;
@property (nonatomic, copy) NSString *transPassword;
@property (nonatomic, copy) NSString *bankBranchProvinceCode;
@property (nonatomic, copy) NSString *bankBranchCityCode;
@property (nonatomic, copy) NSString *bankAddress;

@property (nonatomic, strong, readonly) MSFAddressViewModel *addressViewModel;

@property (nonatomic, strong) MSFBankInfoModel *bankInfo;

@property (nonatomic, copy) NSString *maxSize;

@property (nonatomic, strong) NSString *bankCode;

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, copy) NSString *bankType;

@property (nonatomic, strong, readonly) RACCommand *executeAddBankCard;

@property (nonatomic, strong, readonly) RACCommand *executeSelected;

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

@property (nonatomic, assign) BOOL isFirstBankCard;
// 拉取支持的银行
@property (nonatomic, copy, readonly) NSString *supportBanks;

- (instancetype)initWithServices:(id <MSFViewModelServices>)services andIsFirstBankCard:(BOOL)isFirstBankCard;

@end
