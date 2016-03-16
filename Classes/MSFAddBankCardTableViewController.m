//
//  MSFAddBankCardTableViewController.m
//  Finance
//
//  Created by xbm on 15/9/29.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFAddBankCardTableViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFBankInfoModel.h"
#import "MSFEdgeButton.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <SHSPhoneComponent/SHSPhoneTextField.h>

#import "MSFInputTradePasswordViewController.h"
#import "MSFGetBankIcon.h"
#import "MSFUser.h"
#import "MSFClient.h"

static NSString *bankCardShowStrB = @"提示：主卡不能为贷记卡。";
static NSString *bankCardShowStrC = @"你的银行卡号长度有误，请修改后再试";

@interface MSFAddBankCardTableViewController ()<MSFInputTradePasswordDelegate>
@property (weak, nonatomic) IBOutlet UITextField *bankAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *bankNOTF;

@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;
@property (weak, nonatomic) IBOutlet UILabel *bankWarningLB;

@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *submitBT;
@property (weak, nonatomic) IBOutlet UILabel *bankCarTypeLB;

@property (nonatomic, copy) NSString *tradePwd;
@property (nonatomic, copy) NSMutableAttributedString *supportBanks;

@property (nonatomic, strong) MSFInputTradePasswordViewController *inputTradePassword;

@end

@implementation MSFAddBankCardTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"添加银行卡";
	_tradePwd = @"";
	
	RAC(self, viewModel.transPassword) = RACObserve(self, tradePwd);
	RAC(self, bankIcon.image) = [RACObserve(self, viewModel.bankCode) map:^id(NSString *value) {
		return [UIImage imageNamed:[MSFGetBankIcon getIconNameWithBankCode:value]];
	}];
	RAC(self.bankAddressTF, text) = RACObserve(self.viewModel, bankAddress);
	
	_inputTradePassword = [UIStoryboard storyboardWithName:@"InputTradePassword" bundle:nil].instantiateInitialViewController;
	_inputTradePassword.delegate = self;
	
	@weakify(self)
	[RACObserve(self, viewModel.supportBanks) subscribeNext:^(id x) {
		if ([x isKindOfClass:NSString.class]) {
			self.supportBanks = [[NSMutableAttributedString alloc] initWithString:x];
		}
		[self refreshInformation:self.viewModel.bankInfo.support];
	}];
	
	RAC(self.bankNameTF, text) = RACObserve(self.viewModel, bankName);
	[RACObserve(self.viewModel, bankName) subscribeNext:^(NSString *bankName) {
		@strongify(self)
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		self.bankNameTF.alpha = 1.0;
		[UIView commitAnimations];
	}];
	
	[RACObserve(self, viewModel.bankInfo.support) subscribeNext:^(NSString *support) {
		@strongify(self)
		[self refreshInformation:support];
	}];
	
	RAC(self.bankCarTypeLB, text) = [[RACObserve(self.viewModel, bankType) ignore:nil] map:^id(id value) {
		return value;
	}];
	[[RACObserve(self.viewModel, bankType) ignore:nil] subscribeNext:^(NSString *type) {
		@strongify(self)
		if (type != nil && ![type isEqualToString:@""] ) {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.01];
			self.bankCarTypeLB.alpha = 1.0;
			[UIView commitAnimations];
		} else {
			self.bankCarTypeLB.alpha = 0;
		}
		
	}];
	
	[[self.submitBT rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext:^(id x) {
		 @strongify(self)
		 MSFUser *user = [self.viewModel.services httpClient].user;
		 if (!user.hasTransactionalCode) {
			 MSFInputTradePasswordViewController *inputTradePassword = [UIStoryboard storyboardWithName:@"InputTradePassword" bundle:nil].instantiateInitialViewController;
			 [[UIApplication sharedApplication].keyWindow addSubview:inputTradePassword.view];
		 } else {
			 self.inputTradePassword.type = 2;
			 [[UIApplication sharedApplication].keyWindow addSubview:self.inputTradePassword.view];
		 }
	 }];
	
	[[(SHSPhoneTextField *)self.bankNOTF formatter] setDefaultOutputPattern:@"#### #### #### #### ###"];
	((SHSPhoneTextField *)self.bankNOTF).textDidChangeBlock = ^(UITextField *textField){
		@strongify(self)
		self.viewModel.bankNO = textField.text;
	};
}

- (void)refreshInformation:(NSString *)support {
	switch (support.intValue) {
		case 2:
			if (!self.viewModel.isFirstBankCard) {
				break;
			}
			self.bankWarningLB.text = bankCardShowStrB;
			break;
		default:
			[self.bankWarningLB setAttributedText:self.supportBanks];
			break;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 1) {
		[_viewModel.executeSelected execute:nil];
	}
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (void)getTradePassword:(NSString *)pwd type:(int)type {
	[SVProgressHUD showWithStatus:@"正在绑定银行卡..." maskType:SVProgressHUDMaskTypeClear];
	self.tradePwd = pwd;
	if (type == 2) {
		@weakify(self)
		[[self.viewModel.executeAddBankCard execute:nil]
		 subscribeCompleted:^{
			 @strongify(self)
			 [self.view endEditing:YES];
			 [SVProgressHUD showSuccessWithStatus:@"绑卡成功"];
			 [self.navigationController popViewControllerAnimated:YES];
		 } ];
		[self.viewModel.executeAddBankCard.errors subscribeNext:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
	}
}

@end
