//
//  MSFFindwordLastTableViewController.m
//  Finance
//
//  Created by xbm on 16/2/22.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFFindwordLastTableViewController.h"
#import "MSFAuthorizeViewModel.h"

@interface MSFFindwordLastTableViewController ()

@property (nonatomic, strong) MSFAuthorizeViewModel *viewModle;

@end

@implementation MSFFindwordLastTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindViewModel:(id)viewModel {
	self.viewModle = viewModel;
}

@end
