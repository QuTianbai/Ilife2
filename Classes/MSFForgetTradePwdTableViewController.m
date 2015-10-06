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
#import "MSFAddBankCardVIewModel.h"
#import "MSFBankInfoModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <REFormattedNumberField/REFormattedNumberField.h>
#import "MSFAuthorizeViewModel.h"
#import "AppDelegate.h"

static NSString *bankCardShowInfoStrA = @"目前只支持工商银行、农业银行、中国银行、建设银行、招商银行、邮政储蓄银行、兴业银行、光大银行、民生银行、中信银行、广发银行的借记卡。请换卡再试。";
static NSString *bankCardShowStrB = @"目前不支持非借记卡类型的银行卡，请换卡再试。";
static NSString *bankCardShowStrC = @"你的银行卡号长度有误，请修改后再试";

@interface MSFForgetTradePwdTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *bankAddressTF;
@property (weak, nonatomic) IBOutlet UITextField *bankNOTF;

@property (weak, nonatomic) IBOutlet UILabel *bankNameTF;
@property (weak, nonatomic) IBOutlet UILabel *bankWarningLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bankInfoCS;

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
@property (nonatomic, strong) MSFAddBankCardVIewModel *viewModel;

@end

@implementation MSFForgetTradePwdTableViewController

- (instancetype)initWithViewModel:(id)viewModel AndAuthViewModel:(id)authViewModel {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ForgetTradePwd" bundle:nil];
	self = storyboard.instantiateInitialViewController;
	if (!self) {
		return nil;
	}
//	_viewModel = viewModel;
//	_authviewModel = authViewModel;
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"忘记交易密码";
	//_viewModel = viewModel;
	AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	_authviewModel = appdelegate.authorizeVewModel;
	_viewModel = [[MSFAddBankCardVIewModel alloc] initWithServices:self.authviewModel.services andIsFirstBankCard:NO];
	
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
	
	[[self.checkCodeBT rac_signalForControlEvents:UIControlEventTouchUpInside]
	subscribeNext:^(id x) {
		NSLog(@"jfds");
	}];
	
	self.checkCodeBT.rac_command = self.authviewModel.executeCaprchForgetTradePwd;
	
	RAC(self, countLB.text) = RACObserve(self, authviewModel.counter);
	
	@weakify(self)
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
		[authSignal subscribeCompleted:^{
			[SVProgressHUD showSuccessWithStatus:@"重置交易密码成功"];
			[self.navigationController popViewControllerAnimated:YES];
		}];
	}];
	[self.submitBT.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	[(REFormattedNumberField *)self.bankNOTF setFormat:@"XXXX XXXX XXXX XXXX XXX"];
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 15;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 1) {
		[_viewModel.executeSelected execute:nil];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
