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
#import <REFormattedNumberField/REFormattedNumberField.h>
#import "MSFEdgeButton.h"
#import <SVProgressHUD/SVProgressHUD.h>

#import "MSFInputTradePasswordViewController.h"
#import "MSFInputTradePasswordView.h"
#import "MSFUtils.h"


static NSString *bankCardShowInfoStrA = @"目前只支持工商银行、农业银行、中国银行、建设银行、招商银行、邮政储蓄银行、兴业银行、光大银行、民生银行、中信银行、广发银行的借记卡。请换卡再试。";
static NSString *bankCardShowStrB = @"目前不支持非借记卡类型的银行卡，请换卡再试。";
static NSString *bankCardShowStrC = @"你的银行卡号长度有误，请修改后再试";

@interface MSFAddBankCardTableViewController ()<MSFInputTradePasswordDelegate>
@property (weak, nonatomic) IBOutlet UITextField *bankAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *bankNOTF;

@property (weak, nonatomic) IBOutlet UILabel *bankNameTF;
@property (weak, nonatomic) IBOutlet UILabel *bankWarningLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankInfoCS;

@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *submitBT;
@property (weak, nonatomic) IBOutlet UILabel *bankCarTypeLB;

@property (nonatomic, copy) NSString *tradePwd;

@property (nonatomic, strong) MSFInputTradePasswordViewController *inputTradePassword;

@end

@implementation MSFAddBankCardTableViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"添加银行卡";
	_tradePwd = @"";
	
	RAC(self, viewModel.transPassword) = RACObserve(self, tradePwd);
	
	_inputTradePassword = [UIStoryboard storyboardWithName:@"InputTradePassword" bundle:nil].instantiateInitialViewController;
	_inputTradePassword.delegate = self;
	RAC(self.bankAddressTF, text) = RACObserve(self.viewModel, bankAddress);
//	 self.viewModelServices = [[MSFViewModelServicesImpl alloc] init];
	self.bankWarningLB.numberOfLines = 0;
	NSMutableAttributedString *bankCardShowInfoAttributeStr = [[NSMutableAttributedString alloc] initWithString:bankCardShowInfoStrA];
	NSRange redRange = [bankCardShowInfoStrA rangeOfString:@"工商银行、农业银行、中国银行、建设银行、招商银行、邮政储蓄银行、兴业银行、光大银行、民生银行、中信银行、广发银行"];
	[bankCardShowInfoAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
	
	RAC(self.bankNameTF, text) = RACObserve(self.viewModel, bankName);
	[RACObserve(self.viewModel, bankName) subscribeNext:^(NSString *bankName) {
		if (bankName != nil && ![bankName isEqualToString:@""]) {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.3];
			self.bankNameTF.alpha = 1.0;
			[UIView commitAnimations];
		} else {
			self.bankNameTF.alpha = 0;
		}
		
	}];
	
	RAC(self.viewModel, bankNO) = self.bankNOTF.rac_textSignal;//银行卡号
	
	[RACObserve(self.viewModel, bankInfo.support) subscribeNext:^(NSString *support) {
		CGFloat alpha = 0;
		switch (support.intValue) {
			case 1:
				alpha = 1.0;
				[self.bankWarningLB setAttributedText:bankCardShowInfoAttributeStr];
				self.bankInfoCS.constant = 100;
				break;
			case 2:
				if (!self.viewModel.isFirstBankCard) {
					break;
				}
				alpha = 1.0;
				self.bankWarningLB.text = bankCardShowStrB;
				self.bankInfoCS.constant = 50;
				break;
			case 0:
			case 3:
				self.bankWarningLB.text = @"";
				self.bankInfoCS.constant = 25;
				break;
			default:
    break;
		}
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.3];
		self.bankWarningLB.alpha = alpha;
		[UIView commitAnimations];
		
	}];
	
	RAC(self.bankCarTypeLB, text) = [[RACObserve(self.viewModel, bankType) ignore:nil] map:^id(id value) {
		return value;
	}];
	[[RACObserve(self.viewModel, bankType) ignore:nil] subscribeNext:^(NSString *type) {
		if (type != nil && ![type isEqualToString:@""] ) {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.3];
			self.bankCarTypeLB.alpha = 1.0;
			[UIView commitAnimations];
		} else {
			self.bankCarTypeLB.alpha = 0;
		}
		
	}];
	
	[[self.submitBT rac_signalForControlEvents:UIControlEventTouchUpInside]
	subscribeNext:^(id x) {
		if ([MSFUtils.isSetTradePassword isEqualToString:@"NO"]) {
			MSFInputTradePasswordViewController * inputTradePassword = [UIStoryboard storyboardWithName:@"InputTradePassword" bundle:nil].instantiateInitialViewController;
			[[UIApplication sharedApplication].keyWindow addSubview:inputTradePassword.view];
		} else {
			self.inputTradePassword.type = 2;
			[[UIApplication sharedApplication].keyWindow addSubview:self.inputTradePassword.view];
		}
	}];
	
//	self.submitBT.rac_command = self.viewModel.executeAddBankCard;
//	@weakify(self)
//	[self.submitBT.rac_command.executionSignals subscribeNext:^(RACSignal *authSignal) {
//		@strongify(self)
//		[self.view endEditing:YES];
//		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
//		[authSignal subscribeNext:^(id x) {
//			
//			[SVProgressHUD showSuccessWithStatus:@"绑卡成功"];
//		}];
//	}];
//	[self.submitBT.rac_command.errors subscribeNext:^(NSError *error) {
//		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
//	}];
	
	[(REFormattedNumberField *)self.bankNOTF setFormat:@"XXXX XXXX XXXX XXXX XXX"];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
	self.tradePwd = pwd;
	if (type == 2) {
		@weakify(self)
		[[self.viewModel.executeAddBankCard execute:nil]
		subscribeNext:^(RACSignal *signal) {
			@strongify(self)
			[self.view endEditing:YES];
//			[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
//			[signal subscribeNext:^(id x) {
				[SVProgressHUD showSuccessWithStatus:@"绑卡成功"];
				[self.navigationController popViewControllerAnimated:YES];
			//}];
//			[authSignal subscribeNext:^(id x) {
//				
//				[SVProgressHUD showSuccessWithStatus:@"绑卡成功"];
		} error:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
	}
	
}


@end
