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
#import "UIColor+Utils.h"

#import "MSFTabBarController.h"
#import "MSFTabBarViewModel.h"
#import "MSFFormsViewModel.h"

static NSString *bankCardShowInfoStrA = @"目前只支持邮储银行、工商银行、中国银行、建设银行、中信银行、光大银行、民生银行、广发银行、兴业银行的借记卡。请换卡再试。";
//static NSString *bankCardShowStrB = @"主卡不能为贷记卡。";
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
	
	_inputTradePassword = [UIStoryboard storyboardWithName:@"InputTradePassword" bundle:nil].instantiateInitialViewController;
	_inputTradePassword.delegate = self;
	RAC(self.bankAddressTF, text) = RACObserve(self.viewModel, bankAddress);
//	 self.viewModelServices = [[MSFViewModelServicesImpl alloc] init];
	self.bankWarningLB.numberOfLines = 0;
	NSMutableAttributedString *bankCardShowInfoAttributeStr = [[NSMutableAttributedString alloc] initWithString:bankCardShowInfoStrA];
	NSRange redRange = [bankCardShowInfoStrA rangeOfString:@"工商银行、中国银行、建设银行、邮政储蓄银行、兴业银行、光大银行、民生银行、中信银行、广发银行"];
	[bankCardShowInfoAttributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
	
	RAC(self.bankNameTF, text) = RACObserve(self.viewModel, bankName);
	@weakify(self)
	[RACObserve(self.viewModel, bankName) subscribeNext:^(NSString *bankName) {
		//if (bankName != nil && ![bankName isEqualToString:@""]) {
		@strongify(self)
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.3];
			self.bankNameTF.alpha = 1.0;
			[UIView commitAnimations];
//		} else {
//			self.bankNameTF.alpha = 1.0;
//		}
		
	}];
	
	
	[RACObserve(self.viewModel, bankInfo.support) subscribeNext:^(NSString *support) {
		@strongify(self)
		CGFloat alpha = 1.0;
		switch (support.intValue) {
			case 1:
				[self.bankWarningLB setAttributedText:bankCardShowInfoAttributeStr];
				break;
			case 2:
				if (!self.viewModel.isFirstBankCard) {
					break;
				}
				self.bankWarningLB.text = bankCardShowStrB;
				break;
			default:
				[self.bankWarningLB setAttributedText:[bankCardShowInfoAttributeStr attributedSubstringFromRange:NSMakeRange(0, bankCardShowInfoAttributeStr.length - 6)]];
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
		@strongify(self)
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

	[[(SHSPhoneTextField *)self.bankNOTF formatter] setDefaultOutputPattern:@"#### #### #### #### ###"];
	((SHSPhoneTextField *)self.bankNOTF).textDidChangeBlock = ^(UITextField *textField){
		@strongify(self)
		self.viewModel.bankNO = textField.text;
	};
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return nil;
	}
	UIView *reuse = [[UIView alloc] init];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
	label.font = [UIFont boldSystemFontOfSize:15];
	label.textColor = UIColor.themeColorNew;
	switch (section) {
		case 1: label.text = @"基本信息"; break;
		case 2: label.text = @"职业信息"; break;
		case 3: label.text = @"联系人信息"; break;
		case 4: label.text = @"参保信息"; break;
		default: break;
	}
	[reuse addSubview:label];
	return reuse;
}

- (void)getTradePassword:(NSString *)pwd type:(int)type {
	[SVProgressHUD showWithStatus:@"正在绑定银行卡..." maskType:SVProgressHUDMaskTypeClear];
	self.tradePwd = pwd;
	if (type == 2) {
		@weakify(self)
		[[self.viewModel.executeAddBankCard execute:nil]
		subscribeCompleted:^{
			@strongify(self)
			[self refreshFormsViewModel];
			[self.view endEditing:YES];
			[SVProgressHUD showSuccessWithStatus:@"绑卡成功"];
			[self.navigationController popViewControllerAnimated:YES];
		} ];
		[self.viewModel.executeAddBankCard.errors subscribeNext:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];

	}
}

- (void)refreshFormsViewModel {
	MSFTabBarController *tabbar = (MSFTabBarController *)self.tabBarController;
	tabbar.viewModel.formsViewModel.active = NO;
	tabbar.viewModel.formsViewModel.active = YES;
}

@end
