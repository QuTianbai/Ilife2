//
//  MSFDrawCashTableViewController.m
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFDrawCashTableViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFEdgeButton.h"
#import "MSFDrawCashViewModel.h"
#import "MSFInputTradePasswordViewController.h"
#import "MSFResponse.h"
#import "MSFCirculateCashModel.h"
#import "MSFSmsCodeTableViewController.h"
#import "MSFRepaymentSchedulesViewModel.h"
#import "MSFPaymentToken.h"

@interface MSFDrawCashTableViewController () <MSFInputTradePasswordDelegate>

@property (weak, nonatomic) IBOutlet UILabel *showInfoLB;
@property (weak, nonatomic) IBOutlet UILabel *warningLB;
@property (weak, nonatomic) IBOutlet UIImageView *bankImg;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankNo;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UITextField *inputMoneyTF;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *submitBT;

@property (nonatomic, strong) MSFInputTradePasswordViewController *inputTradePassword;
@property (nonatomic, strong) MSFDrawCashViewModel *viewModel;

@property (nonatomic, strong) MSFRepaymentSchedulesViewModel *repayViewModel;

@property (nonatomic, assign) int type;

@end

@implementation MSFDrawCashTableViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [UIStoryboard storyboardWithName:@"DrawCash" bundle:nil].instantiateInitialViewController;
	if (self) {
		_viewModel = viewModel;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setviewTitle];
	_inputTradePassword = [UIStoryboard storyboardWithName:@"InputTradePassword" bundle:nil].instantiateInitialViewController;
	_inputTradePassword.delegate = self;
	RAC(self.bankName, text) = RACObserve(self, viewModel.bankName);
	RAC(self.bankNo, text) = RACObserve(self, viewModel.bankCardNO);
	RAC(self.moneyLB, text) = RACObserve(self, viewModel.money);
	
	RAC(self.bankImg, image) = [RACObserve(self, viewModel.bankIcon) map:^id(NSString *value) {
		UIImage *img = [UIImage imageNamed:value];
		return img;
	}];
	
	RACChannelTerminal *drawCashChannel = RACChannelTo(self.viewModel, drawCash);
	RAC(self.inputMoneyTF, text) = drawCashChannel;
	[self.inputMoneyTF.rac_textSignal subscribe:drawCashChannel];
	
	@weakify(self)
	[[self.submitBT rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		if (self.viewModel.type == 0) {
			if (self.viewModel.circulateViewModel.usableLimit.floatValue < self.viewModel.drawCash.floatValue) {
				[SVProgressHUD showInfoWithStatus:@"提现金额超出您的额度"];
				return;
			}
		} else {
			if (self.viewModel.drawCash.floatValue > self.viewModel.circulateViewModel.totalOverdueMoney.floatValue) {
				[SVProgressHUD showInfoWithStatus:@"还款金额大于欠款金额"];
				return;
			}
			if (self.viewModel.circulateViewModel.totalOverdueMoney <=0 ) {
				[SVProgressHUD showInfoWithStatus:@"您无欠款金额"];
				return;
			}
		}
		[[UIApplication sharedApplication].keyWindow addSubview:self.inputTradePassword.view];
	 }];
}

- (void)setviewTitle {
	if (self.viewModel.type == 1 || self.viewModel.type == 2) {
		self.title = @"还款";
		self.showInfoLB.text = @"还款金额从此银行账户代扣";
		self.warningLB.text = @"";
		[self.submitBT setTitle:@"确认还款" forState:UIControlStateNormal];
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

#pragma mark - MSFInputTradePasswordDelegate

- (void)getTradePassword:(NSString *)pwd type:(int)type {
	NSString *str = @"正在提现...";
	if (self.viewModel.type == 1 || self.viewModel.type == 2) {
		str = @"正在验证";
	}
	
	self.viewModel.tradePWd = pwd;
	
	@weakify(self)
	// 提现验证
	if (self.viewModel.type == 1 || self.viewModel.type == 2) {
		[SVProgressHUD showWithStatus:str maskType:SVProgressHUDMaskTypeClear];
		MSFSmsCodeTableViewController *paySmsCodeVC = [[MSFSmsCodeTableViewController alloc] initWithViewModel:self.viewModel];
		[[self.viewModel.executeSubmitCommand execute:nil] subscribeNext:^(id x) {
			@strongify(self)
			[SVProgressHUD dismiss];
			[self.navigationController pushViewController:paySmsCodeVC animated:YES];
		} error:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
		[self.viewModel.executeSubmitCommand.errors subscribeNext:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
		return;
	}
	
	// 提现确认
	[SVProgressHUD showWithStatus:str maskType:SVProgressHUDMaskTypeClear];
	[[self.viewModel.executeSubmitCommand execute:nil] subscribeNext:^(MSFResponse *response) {
		@strongify(self)
		 NSDictionary *result = response.parsedResult;
		 NSString *str = result[@"message"];
		 [SVProgressHUD showSuccessWithStatus:str];
		 [self.navigationController popViewControllerAnimated:YES];
	 }];
	
	[self.viewModel.executeSubmitCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
}

@end
