//
//  MSFWalletRepayViewModel.h
//  Finance
//
//  Created by Wyc on 16/3/17.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//
#import "MSFViewModelServices.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFRepayPlayMode.h"
#import "MSFViewModelServices.h"

@interface MSFWalletRepayViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, strong) RACCommand  *executeBankList;

- (instancetype)initWithServices:(id<MSFViewModelServices>)servers;

- (MSFRepayPlayMode *)getRepayPlayMode:(NSInteger)integer;
- (RACSignal *)fetchRepayInformationSignal;

@end
