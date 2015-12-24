//
//  MSFSmsCodeTableViewController.m
//  Finance
//
//  Created by xbm on 15/12/24.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSmsCodeTableViewController.h"
#import "MSFDrawCashViewModel.h"

@interface MSFSmsCodeTableViewController ()

@property (nonatomic, strong) MSFDrawCashViewModel *viewModel;

@end

@implementation MSFSmsCodeTableViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [UIStoryboard storyboardWithName:@"paySmsCodeStoryboard" bundle:nil].instantiateInitialViewController;
	if (!self) {
		return nil;
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
