//
//  MSFDrawCashTableViewController.m
//  Finance
//
//  Created by xbm on 15/10/1.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFDrawCashTableViewController.h"
#import "MSFEdgeButton.h"
#import "MSFDrawCashViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFInputTradePasswordViewController.h"
#import "MSFUtils.h"
#import "MSFResponse.h"
#import "MSFCirculateCashModel.h"

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

@end

@implementation MSFDrawCashTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setviewTitle];
	_inputTradePassword = [UIStoryboard storyboardWithName:@"InputTradePassword" bundle:nil].instantiateInitialViewController;
	_inputTradePassword.delegate = self;
	RAC(self.bankImg, image) = [RACObserve(self, viewModel.bankIcon) map:^id(NSString *value) {
		UIImage *img = [UIImage imageNamed:value];
		return img;
	}];
	RAC(self.bankName, text) = RACObserve(self, viewModel.bankName);
	RAC(self.bankNo, text) = RACObserve(self, viewModel.bankCardNO);
	RAC(self.moneyLB, text) = RACObserve(self, viewModel.money);
	
	//RAC(self.inputMoneyTF, text) = RACObserve(self.viewModel, drawCash);
	
	RACChannelTerminal *drawCashChannel = RACChannelTo(self.viewModel, drawCash);
	RAC(self.inputMoneyTF, text) = drawCashChannel;
	[self.inputMoneyTF.rac_textSignal subscribe:drawCashChannel];
	
	[[self.submitBT rac_signalForControlEvents:UIControlEventTouchUpInside]
	subscribeNext:^(id x) {
		[[UIApplication sharedApplication].keyWindow addSubview:self.inputTradePassword.view];
	}];
	
}

- (void)setviewTitle {
	if (self.type == 1) {
		self.title = @"还款";
		self.showInfoLB.text = @"还款金额从此银行账户代扣";
		self.warningLB.text = @"";
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
	if (self.type == 1) {
		str = @"正在还款";
	}
	
	[SVProgressHUD showWithStatus:str maskType:SVProgressHUDMaskTypeClear];
	
	self.viewModel.tradePWd = pwd;
	[[self.viewModel.executeSubmitCommand execute:nil]
	 subscribeNext:^(MSFResponse *response) {
		 //[SVProgressHUD showSuccessWithStatus:@"主卡设置成功"];
//		 NSDictionary *result = response.parsedResult;
		
		 
		 NSDictionary *result = response.parsedResult;
		 NSString *str = result[@"message"];
		 if (self.type == 1) {
			 str = @"恭喜你，还款已成功";
			 //NSDictionary *result = response.parsedResult;
			 MSFCirculateCashModel *mocel = [MTLJSONAdapter modelOfClass:[MSFCirculateCashModel class] fromJSONDictionary:response.parsedResult error:nil];
			 self.viewModel.circulateViewModel.infoModel = mocel;
		 }
		 [SVProgressHUD showSuccessWithStatus:str];
		 [self.navigationController popViewControllerAnimated:YES];
	 }];
	
	[self.viewModel.executeSubmitCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
}

@end
