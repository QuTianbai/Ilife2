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

@interface MSFSmsCodeTableViewController ()

@property (nonatomic, strong) MSFDrawCashViewModel *viewModel;
@property (nonatomic, strong) MSFRepaymentSchedulesViewModel *payViewModel;
@property (weak, nonatomic) IBOutlet UITextField *smsCodeTF;
@property (weak, nonatomic) IBOutlet UIImageView *sendCaptchaView;
@property (weak, nonatomic) IBOutlet UILabel *countLB;
@property (weak, nonatomic) IBOutlet UIButton *smsCodeBT;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *submitBT;

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
	[[self.smsCodeTF rac_signalForControlEvents:UIControlEventEditingChanged]
	 subscribeNext:^(UITextField *textField) {
		 if (textField.text.length > 4) {
			 textField.text = [textField.text substringToIndex:4];
		 }
	 }];
	self.submitBT.rac_command = self.viewModel.executeSubmitCommand;
	if (self.viewModel.type == 1) {
		[self.viewModel.executeSubmitCommand.executionSignals subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"恭喜你，还款已成功"];
			MSFCirculateCashModel *mocel = x;
			self.viewModel.circulateViewModel.infoModel = mocel;
			 [self.navigationController popToRootViewControllerAnimated:YES];
		}];
		
		RAC(self, viewModel.smsCode) = self.smsCodeTF.rac_textSignal;
	} else {
		[self.submitBT.rac_command.executionSignals subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"恭喜你，还款已成功"];
			[self.navigationController popToRootViewControllerAnimated:YES];
		}];
		
		RAC(self, payViewModel.smsCode) = self.smsCodeTF.rac_textSignal;
	}
	
	[self.submitBT.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];

	RAC(self, countLB.text) = RACObserve(self, authviewModel.counter);
	
	self.smsCodeBT.rac_command = self.authviewModel.executePayCommand;
	@weakify(self)
	[self.smsCodeBT.rac_command.executionSignals subscribeNext:^(RACSignal *captchaSignal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在获取验证码" maskType:SVProgressHUDMaskTypeClear];
		[captchaSignal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
		}];
	}];
	
	[self.smsCodeBT.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	[self.authviewModel.captchaRequestValidSignal subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.countLB.textColor = value.boolValue ? UIColor.whiteColor: [UIColor blackColor];
		self.sendCaptchaView.image = value.boolValue ? self.authviewModel.captchaNomalImage : self.authviewModel.captchaHighlightedImage;
	}];
	
	
	
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
