//
// MSFFindPasswordViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFFindPasswordViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFAuthorizeViewModel.h"
#import "MSFUtils.h"
#import "UITextField+RACKeyboardSupport.h"

@interface MSFFindPasswordViewController ()

@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;

@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *captcha;
@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) IBOutlet UIButton *captchaButton;
@property (nonatomic, weak) IBOutlet UIButton *commitButton;
@property (nonatomic, weak) IBOutlet UILabel *counterLabel;

@end

@implementation MSFFindPasswordViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.username.text = MSFUtils.phone;
	RAC(self.viewModel, username) = self.username.rac_textSignal;
	RAC(self.viewModel, captcha) = self.captcha.rac_textSignal;
	RAC(self.viewModel, password) = self.password.rac_textSignal;
	RAC(self.counterLabel, text) = RACObserve(self.viewModel, counter);
	RAC(self.counterLabel, textColor) =
	[self.viewModel.captchaRequestValidSignal
		map:^id(NSNumber *valid) {
			return valid.boolValue ? UIColor.whiteColor : UIColor.lightGrayColor;
	}];
	@weakify(self)
	self.captchaButton.rac_command = self.viewModel.executeFindPasswordCaptcha;
	[self.captchaButton.rac_command.executionSignals subscribeNext:^(RACSignal *captchaSignal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在发送验证码..." maskType:SVProgressHUDMaskTypeClear];
		[captchaSignal subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"验证码发送成功"];
		}];
	}];
	[self.captchaButton.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	self.commitButton.rac_command = self.viewModel.executeFindPassword;
	[self.commitButton.rac_command.executionSignals subscribeNext:^(RACSignal *signUpSignal) {
		@strongify(self)
		[MSFUtils setPhone:self.username.text];
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[signUpSignal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			[self.navigationController popViewControllerAnimated:YES];
		}];
	}];
	
	[self.commitButton.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	[self.password.rac_keyboardReturnSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.viewModel.executeFindPassword execute:nil];
	}];
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end