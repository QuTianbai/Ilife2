//
//  MSFCreditMiddleViewController.m
//  Finance
//
//  Created by Wyc on 16/3/8.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCreditMiddleViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MSFCreditViewModel.h"
#import "MSFPhoto.h"
#import "MSFButtonSlidersView.h"
#import <Masonry.h>
#import "MSFApplyCashViewModel.h"
#import "MSFMSFApplyCashViewController.h"
#import "MSFLoanType.h"

@interface MSFCreditMiddleViewController ()

@property (nonatomic, weak) MSFCreditViewModel *viewModel;

@end

@implementation MSFCreditMiddleViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    MSFButtonSlidersView *slider = [[MSFButtonSlidersView alloc]initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 10)];
    [self.beforeApply addSubview:slider];
    
    UIButton *button = [[UIButton alloc]init];
    //[button setTitle:@"j" forState:UIControlStateNormal];
    [self.beforeApply addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.top.equalTo(@120);
        make.right.equalTo(@(-10));
        make.height.equalTo(@35);
    }];
    
    [button setBackgroundImage:[UIImage imageNamed:@"credit-btn-active.png"] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(apply) forControlEvents:UIControlEventTouchUpInside];
    
    [self.beforeApply addSubview:button];
    
    RAC(self.applyView, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber *status) {
        return @(status.integerValue != MSFCreditActivated);
    }];
//    RAC(self.beforeApply, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber *status) {
//        return  @(status.integerValue == MSFCreditActivated);
//    }];
}

- (void)apply {
    MSFApplyCashViewModel *viewModel = [[MSFApplyCashViewModel alloc] initWithLoanType:[[MSFLoanType alloc] initWithTypeID:@"4102"] services:self.viewModel.services];
    MSFMSFApplyCashViewController *vc = [[MSFMSFApplyCashViewController alloc] initWithViewModel:viewModel];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
