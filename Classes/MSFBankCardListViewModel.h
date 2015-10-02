//
//  MSFBankCardListViewModel.h
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "RVMViewModel.h"
#import "MSFViewModelServices.h"
#import "MSFBankCardInfoViewModel.h"

@class RACCommand;

@interface MSFBankCardListViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;

@property (nonatomic, strong) RACCommand *executeBankList;

@property (nonatomic, strong) RACCommand *executeSetMaster;
@property (nonatomic, strong) RACCommand *executeUnbind;

@property (nonatomic, copy) NSString *pwd;

@property (nonatomic, copy) NSString *bankCardID;

- (instancetype)initWithServices:(id<MSFViewModelServices>)servers;

- (MSFBankCardInfoViewModel *)getBankCardInfoViewModel:(NSInteger)integer;

@end
