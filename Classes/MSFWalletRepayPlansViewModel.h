//
//  MSFWalletRepayViewModel.h
//  Finance
//
//  Created by Wyc on 16/3/17.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//
#import "MSFViewModelServices.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFRepayPlanViewModle.h"
#import "MSFViewModelServices.h"

@interface MSFWalletRepayPlansViewModel : RVMViewModel

@property (nonatomic, weak, readonly) id <MSFViewModelServices> services;
@property (nonatomic, strong) RACCommand  *executeMyRepayPlanList;

@property (nonatomic, strong) RACCommand *executeFetchCommand;

- (instancetype)initWithServices:(id<MSFViewModelServices>)servers viewModel:(id)viewModel;

@end
