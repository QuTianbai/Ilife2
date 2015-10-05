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

@interface MSFDrawCashTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *showInfoLB;
@property (weak, nonatomic) IBOutlet UILabel *warningLB;
@property (weak, nonatomic) IBOutlet UIImageView *bankImg;
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankNo;
@property (weak, nonatomic) IBOutlet UILabel *moneyLB;
@property (weak, nonatomic) IBOutlet UITextField *inputMoneyTF;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *submitBT;




@end

@implementation MSFDrawCashTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self setviewTitle];
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
	
	self.submitBT.rac_command = self.viewModel.executeSubmitCommand;
	[self.viewModel.executeSubmitCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		NSString *str = @"正在提现...";
		if (self.type == 1) {
			str = @"正在还款";
		}
		
		[SVProgressHUD showWithStatus:str maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			NSString *str = @"恭喜你，提款已成功";
			if (self.type == 1) {
				str = @"恭喜你，还款已成功";
			}
			[SVProgressHUD showSuccessWithStatus:str];
		}];
		
	}];
	[self.viewModel.executeSubmitCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
    
	
}

- (void) setviewTitle {
	if (self.type == 1) {
		self.title = @"还款";
		self.showInfoLB.text = @"还款金额从此银行账户代扣";
		self.warningLB.text = @"";
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}


@end