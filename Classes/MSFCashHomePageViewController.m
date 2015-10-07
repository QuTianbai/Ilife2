//
//  MSFCashHomePageViewController.m
//  Finance
//
//  Created by xbm on 15/10/2.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFCashHomePageViewController.h"
#import "MSFEdgeButton.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFApplyCashVIewModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFCheckAllowApply.h"
#import "MSFCirculateCashViewModel.h"
#import "MSFUtils.h"
#import "MSFCirculateCashTableViewController.h"
#import "MSFProductViewController.h"

@interface MSFCashHomePageViewController ()
@property (weak, nonatomic) IBOutlet MSFEdgeButton *nextBT;

@end

@implementation MSFCashHomePageViewController

- (instancetype)initWithViewModel:(MSFApplyCashVIewModel *)viewModel {
	self = [UIStoryboard storyboardWithName:@"CashHomePage" bundle:nil].instantiateInitialViewController;
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	return self;
}

- (void)viewDidLoad {
	
	
    [super viewDidLoad];
	self.nextBT.rac_command = self.viewModel.executeAllowCashCommand;
	
	[self.viewModel.executeAllowCashCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(MSFCheckAllowApply *model) {
			if (model.processing == 1) {
				
				if ([MSFUtils.isCircuteCash isEqualToString:@"1"]) {
					MSFCirculateCashViewModel *viewModel = [[MSFCirculateCashViewModel alloc] initWithServices:self.viewModel.services];
					MSFCirculateCashTableViewController *circulateViewController = [[MSFCirculateCashTableViewController alloc] initWithViewModel:viewModel];
					[self.navigationController pushViewController:circulateViewController animated:YES];
					
				} else {
					MSFProductViewController *productViewController = [[MSFProductViewController alloc] initWithViewModel:self.viewModel];
					[self.navigationController pushViewController:productViewController animated:YES];
				}

				
			} else {
				[[[UIAlertView alloc] initWithTitle:@"提示"
																		message:@"您目前还有一笔贷款正在申请中，暂不能申请贷款。"
																	 delegate:nil
													cancelButtonTitle:@"确认"
													otherButtonTitles:nil] show];
			}
			[SVProgressHUD dismiss];
		}];
	}];
	[self.viewModel.executeAllowCashCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
