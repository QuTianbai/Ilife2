//
//  MSFDrawCashViewModel.h
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFBankCardListModel.h"
#import "MSFViewModelServices.h"
#import "MSFCirculateCashViewModel.h"

@class RACCommand;
@class MSFRepaymentSchedulesViewModel;

@interface MSFDrawCashViewModel : RVMViewModel

@property (nonatomic, copy) NSString *smsCode;

@property (nonatomic, copy) NSString *smsSeqNo;

@property (nonatomic, copy) NSString *bankIcon;

@property (nonatomic, copy) NSString *bankName;

@property (nonatomic, copy) NSString *money;

@property (nonatomic, copy) NSString *bankCardNO;

@property (nonatomic, copy) NSString *drawCash;

@property (nonatomic, copy) NSString *tradePWd;

@property (nonatomic, copy) MSFCirculateCashViewModel *circulateViewModel;

@property (nonatomic, assign) int type;

@property (nonatomic, strong) RACCommand *executeSubmitCommand;
@property (nonatomic, strong) RACCommand *executePayCommand;
@property (nonatomic, strong) RACCommand *executSMSCommand;

@property (nonatomic, strong) MSFRepaymentSchedulesViewModel *repayFinanceViewModel;

- (instancetype)initWithModel:(MSFBankCardListModel *)model AndCirculateViewmodel:(id)viewModel AndServices:(id<MSFViewModelServices>)services AndType:(int)type;

@end
