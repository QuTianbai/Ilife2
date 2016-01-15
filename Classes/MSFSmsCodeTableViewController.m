//
//  MSFSmsCodeTableViewController.m
//  Finance
//
//  Created by xbm on 15/12/24.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSmsCodeTableViewController.h"
#import "MSFDrawCashViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFAuthorizeViewModel.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFRepaymentSchedulesViewModel.h"
#import "MSFEdgeButton.h"
#import "MSFResponse.h"
#import "MSFCirculateCashModel.h"
#import "MSFTransSmsSeqNOModel.h"

@interface MSFSmsCodeTableViewController ()

@property (nonatomic, strong) MSFDrawCashViewModel *viewModel;
@property (nonatomic, strong) MSFRepaymentSchedulesViewModel *payViewModel;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTF;
@property (weak, nonatomic) IBOutlet UIImageView *sendCaptchaView;
@property (weak, nonatomic) IBOutlet UILabel *countLB;
@property (weak, nonatomic) IBOutlet UILabel *bankLabel;
@property (weak, nonatomic) IBOutlet UIButton *smsCodeBT;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *submitBT;
@property (nonatomic, assign) BOOL counting;
@property (nonatomic, strong) NSString *counter;

@property (nonatomic, strong) MSFAuthorizeViewModel *authviewModel;

@end

@implementation MSFSmsCodeTableViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [UIStoryboard storyboardWithName:@"paySmsCodeStoryboard" bundle:nil].instantiateInitialViewController;
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	_authviewModel = appdelegate.authorizeVewModel;
	return self;
}

- (instancetype)initWithPayViewModel:(id)viewModel {
	self = [UIStoryboard storyboardWithName:@"paySmsCodeStoryboard" bundle:nil].instantiateInitialViewController;
	if (!self) {
		return nil;
	}
	_payViewModel = viewModel;
	AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	_authviewModel = appdelegate.authorizeVewModel;
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.submitBT.rac_command = self.viewModel.executePayCommand;
	RAC(self, viewModel.smsCode) = self.smsCodeTF.rac_textSignal;
	if (self.viewModel.type == 1) {
		[self.submitBT.rac_command.executionSignals subscribeNext:^(id x) {
			[SVProgressHUD showWithStatus:@"正在提交..."];
			[x subscribeNext:^(id x) {
				[SVProgressHUD showSuccessWithStatus:@"恭喜你，还款已成功"];
				[self.navigationController popToRootViewControllerAnimated:YES];
			} error:^(NSError *error) {
				[SVProgressHUD dismiss];
			}];
		}];
		
	} else if (self.viewModel.type == 4) {
		self.title = @"支付首付";
		[self.submitBT.rac_command.executionSignals subscribeNext:^(id x) {
			[SVProgressHUD showWithStatus:@"正在提交..."];
			[x subscribeNext:^(id x) {
				[SVProgressHUD showSuccessWithStatus:@"恭喜你，请支付首付"];
				[self.navigationController popToRootViewControllerAnimated:YES];
			} error:^(NSError *error) {
				[SVProgressHUD dismiss];
			}];
		}];
	} else {
		[self.submitBT.rac_command.executionSignals subscribeNext:^(id x) {
			[SVProgressHUD showWithStatus:@"正在提交..."];
			[x subscribeNext:^(id x) {
				[SVProgressHUD showSuccessWithStatus:@"恭喜你，还款已成功"];
				[self.navigationController popToRootViewControllerAnimated:YES];
			} error:^(NSError *error) {
				[SVProgressHUD dismiss];
			}];
		}];
	}
	
	[self.submitBT.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	self.counter = @"获取验证吗";

	RAC(self, countLB.text) = RACObserve(self, counter);
	
	self.smsCodeBT.rac_command = self.viewModel.executSMSCommand;
	@weakify(self)
	[self.smsCodeBT.rac_command.executionSignals subscribeNext:^(RACSignal *captchaSignal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在获取验证码" maskType:SVProgressHUDMaskTypeClear];
		[captchaSignal subscribeNext:^(MSFTransSmsSeqNOModel *model) {
			self.viewModel.smsSeqNo = model.smsSeqNo;
			[SVProgressHUD dismiss];
			self.counting = YES;
				RACSignal *repetitiveEventSignal = [[[RACSignal interval:1 onScheduler:RACScheduler.mainThreadScheduler] take:60] takeUntil:[self rac_signalForSelector:@selector(viewWillDisappear:)]];
				__block int repetCount = 60;
				[repetitiveEventSignal subscribeNext:^(id x) {
					self.counter = [@(--repetCount) stringValue];
				} completed:^{
					self.counter = @"获取验证码";
					self.counting = NO;
				}];
		}];
	}];
	
	RAC(self, viewModel.sending) = RACObserve(self, counting);

	UIImage *captchaHighlightedImage = [[UIImage imageNamed:@"bg-send-captcha-highlighted"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 5) resizingMode:UIImageResizingModeStretch];
	UIImage *captchaNomalImage = [[UIImage imageNamed:@"bg-send-captcha"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 5, 5) resizingMode:UIImageResizingModeStretch];
	
	[RACObserve(self, viewModel.sending) subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.countLB.textColor = value.boolValue ? UIColor.whiteColor: [UIColor blackColor];
		self.sendCaptchaView.image = value.boolValue ? captchaHighlightedImage : captchaNomalImage;
	}];
	
	[self.smsCodeBT.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	[RACObserve(self, viewModel) subscribeNext:^(MSFDrawCashViewModel *viewModel) {
		@strongify(self)
		if (self.viewModel.type == 4) {
			self.bankLabel.text = [NSString stringWithFormat:@"尾号%@%@, 首付金额¥%@元", viewModel.bankCardNO,viewModel.bankName, viewModel.drawCash];
		} else {
			self.bankLabel.text = [NSString stringWithFormat:@"尾号%@%@", viewModel.bankCardNO,viewModel.bankName];
		}
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
