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
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"

@interface MSFFindPasswordViewController ()

@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;

@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *captcha;
@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) IBOutlet UIButton *captchaButton;
@property (nonatomic, weak) IBOutlet UIButton *commitButton;
@property (nonatomic, weak) IBOutlet UILabel *counterLabel;
@property (nonatomic, weak) IBOutlet UIButton *showPasswordButton;

@end

@implementation MSFFindPasswordViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"忘记密码";
	self.username.text = MSFUtils.phone;
	RAC(self.viewModel, username) = self.username.rac_textSignal;
	RAC(self.viewModel, captcha) = self.captcha.rac_textSignal;
	RAC(self.viewModel, password) = self.password.rac_textSignal;
	RAC(self.counterLabel, text) = RACObserve(self.viewModel, counter);
	self.counterLabel.layer.cornerRadius = 5.0;
	self.counterLabel.layer.borderWidth = 1;
	self.counterLabel.layer.borderColor = [UIColor clearColor].CGColor;
	RAC(self.counterLabel, textColor) =
	[self.viewModel.captchaRequestValidSignal
		map:^id(NSNumber *valid) {
			return valid.boolValue ? UIColor.whiteColor : [MSFCommandView getColorWithString:@"999999"];
	}];
	RAC(self.counterLabel, backgroundColor) = [self.viewModel.captchaRequestValidSignal map:^id(NSNumber *value) {
		return value.boolValue ? [UIColor clearColor] : [MSFCommandView getColorWithString:@"cccccc"];
	}];
	@weakify(self)
	self.captchaButton.rac_command = self.viewModel.executeFindPasswordCaptcha;
	[self.captchaButton.rac_command.executionSignals subscribeNext:^(RACSignal *captchaSignal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在获取验证码..." maskType:SVProgressHUDMaskTypeClear];
		[captchaSignal subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"短信已下发,请注意查收"];
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
			[SVProgressHUD showSuccessWithStatus:@"重置密码成功，请重新登录"];
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
	self.password.clearButtonMode = UITextFieldViewModeNever;
	[[self.showPasswordButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.showPasswordButton.selected = !self.showPasswordButton.selected;
		NSString *text = self.password.text;
		self.password.text = text;
		self.password.enabled = NO;
		[self.password setSecureTextEntry:!self.showPasswordButton.selected];
		self.password.enabled = YES;
		[self.password becomeFirstResponder];
	}];
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end