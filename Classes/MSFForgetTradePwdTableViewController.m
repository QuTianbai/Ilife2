//
//  MSFForgetTradePwdTableViewController.m
//  Finance
//
//  Created by xbm on 15/10/3.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFForgetTradePwdTableViewController.h"
#import "MSFEdgeButton.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFAddBankCardViewModel.h"
#import "MSFBankInfoModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <SHSPhoneComponent/SHSPhoneTextField.h>
#import "MSFAuthorizeViewModel.h"
#import "AppDelegate.h"
#import "MSFGetBankIcon.h"
#import "MSFTabBarViewModel.h"

static NSString *bankCardShowStrB = @"目前不支持非借记卡类型的银行卡，请换卡再试。";
static NSString *bankCardShowStrC = @"你的银行卡号长度有误，请修改后再试";

@interface MSFForgetTradePwdTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *bankAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *bankNOTF;

@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;
@property (weak, nonatomic) IBOutlet UILabel *bankWarningLB;

@property (weak, nonatomic) IBOutlet UIImageView *bankIcon;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *submitBT;
@property (weak, nonatomic) IBOutlet UILabel *bankCarTypeLB;

@property (weak, nonatomic) IBOutlet UITextField *tradePasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *sureTradePasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *checkCodeBT;
@property (weak, nonatomic) IBOutlet UILabel *countLB;
@property (weak, nonatomic) IBOutlet UIImageView *sendCaptchaView;
@property (nonatomic, strong) MSFAuthorizeViewModel *authviewModel;
@property (nonatomic, strong) MSFAddBankCardViewModel *viewModel;
@property (nonatomic, strong) NSMutableAttributedString *supportBanks;

@end

@implementation MSFForgetTradePwdTableViewController

- (instancetype)initWithViewModel:(id)viewModel AndAuthViewModel:(id)authViewModel {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ForgetTradePwd" bundle:nil];
	self = storyboard.instantiateInitialViewController;
	if (!self) {
		return nil;
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"忘记交易密码";
	AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	_authviewModel = appdelegate.authorizeVewModel;
	_viewModel = [[MSFAddBankCardViewModel alloc] initWithServices:self.viewModel.services andIsFirstBankCard:NO];
	
	RAC(self, bankIcon.image) = [RACObserve(self, viewModel.bankCode) map:^id(NSString *value) {
		return [UIImage imageNamed:[MSFGetBankIcon getIconNameWithBankCode:value]];
	}];
	
	[[self.tradePasswordTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 6) {
			 textField.text = [textField.text substringToIndex:6];
		 }
	 }];
	RAC(self, viewModel.TradePassword) = self.tradePasswordTF.rac_textSignal;
	
	[[self.sureTradePasswordTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 6) {
			 textField.text = [textField.text substringToIndex:6];
		 }
	 }];
	RAC(self, viewModel.againTradePWD) = self.sureTradePasswordTF.rac_textSignal;
	
	[[self.checkCodeTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 4) {
			 textField.text = [textField.text substringToIndex:4];
		 }
	 }];
	RAC(self, viewModel.smsCode) = self.checkCodeTF.rac_textSignal;
    
	RAC(self.bankAddressTF, text) = RACObserve(self.viewModel, bankAddress);
	
	
	@weakify(self)
	[RACObserve(self, viewModel.supportBanks) subscribeNext:^(id x) {
		@strongify(self)
		if ([x isKindOfClass:NSString.class]) {
			if (((NSString *)x).length == 0) {
				return ;
			}
			self.supportBanks = [[NSMutableAttributedString alloc] initWithString:x];
			//前5个字为“目前只支持”
			
			NSRange redRange = NSMakeRange(5, self.supportBanks.length - 5);
			[self.supportBanks addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:redRange];
		}
		[self refreshInformation:self.viewModel.bankInfo.support];
	}];
	
	RAC(self.bankNameTF, text) = [RACObserve(self.viewModel, bankName) map:^id(NSString *value) {
		if ([value isEqualToString:@""]) {
			return @"请输入正确的银行卡号";
		}
		return value;
	}];
	
	[RACObserve(self.viewModel, bankName) subscribeNext:^(NSString *bankName) {
		@strongify(self)
		if (bankName != nil && ![bankName isEqualToString:@""]) {
			[UIView beginAnimations:nil context:nil];
			[UIView setAnimationDuration:0.3];
			self.bankNameTF.alpha = 1.0;
			[UIView commitAnimations];
		} else {
			self.bankNameTF.alpha = 1.0;
			bankName = @"请输入正确的银行卡号";
		}
		
	}];
	
	RAC(self.viewModel, bankNO) = self.bankNOTF.rac_textSignal;//银行卡号
	
	[RACObserve(self.viewModel, bankInfo.support) subscribeNext:^(NSString *support) {
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
			[UIView setAnimationDuration:0.3];
			self.bankCarTypeLB.alpha = 1.0;
			[UIView commitAnimations];
		} else {
			self.bankCarTypeLB.alpha = 0;
		}
	}];
	
	self.checkCodeBT.rac_command = self.authviewModel.executeCaprchForgetTradePwd;
	
	RAC(self, countLB.text) = RACObserve(self, authviewModel.counter);
	
	[self.checkCodeBT.rac_command.executionSignals subscribeNext:^(RACSignal *captchaSignal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在获取验证码" maskType:SVProgressHUDMaskTypeClear];
		[captchaSignal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
		}];
	}];
	
	[self.checkCodeBT.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	
	[self.authviewModel.captchaRequestValidSignal subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.countLB.textColor = value.boolValue ? UIColor.whiteColor: [UIColor blackColor];
		self.sendCaptchaView.image = value.boolValue ? self.authviewModel.captchaNomalImage : self.authviewModel.captchaHighlightedImage;
	}];
	
	self.submitBT.rac_command = self.viewModel.executeReSetTradePwd;
	[self.submitBT.rac_command.executionSignals subscribeNext:^(RACSignal *authSignal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[authSignal subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"重置交易密码成功"];
			[self.navigationController popViewControllerAnimated:YES];
		}];
	}];
	[self.submitBT.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
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

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.authviewModel.active = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.authviewModel.active = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		[_viewModel.executeSelected execute:nil];
	}
}

@end
