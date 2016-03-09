//
//  MSFCreditHeaderViewController.m
//  Finance
//
//  Created by Wyc on 16/3/8.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCreditHeaderViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCreditViewModel.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MSFCreditHeaderViewController ()

@property (nonatomic, weak) MSFCreditViewModel *viewModel;

@end

@implementation MSFCreditHeaderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    RAC(self.titleLabel, text) = RACObserve(self, viewModel.title);
    RAC(self.subtitleLabel, text) = RACObserve(self, viewModel.subtitle);
    RAC(self.repayLabel, text) = RACObserve(self, viewModel.repayAmmounts);
    RAC(self.applyLabel, text) = RACObserve(self, viewModel.applyAmounts);
    RAC(self.applyMonthLabel, text) = RACObserve(self, viewModel.repayDates);
    
    RAC(self.applyView, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber  *status) {
        return @(!(status.integerValue < MSFCreditActivated));
    }];
//    RAC(self.beforeApplyView, hidden)
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
    
}

@end
