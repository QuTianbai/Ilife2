//
// MSFSignUpViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSignUpViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <libextobjc/extobjc.h>
#import "MSFAuthorizeViewModel.h"
#import "MSFUtils.h"
#import "UITextField+RACKeyboardSupport.h"

static NSString *const MSFAutoinputDebuggingEnvironmentKey = @"INPUT_AUTO_DEBUG";

@interface MSFSignUpViewController ()

@property(nonatomic,weak) IBOutlet UITextField *username;
@property(nonatomic,weak) IBOutlet UITextField *captcha;
@property(nonatomic,weak) IBOutlet UITextField *password;

@property(nonatomic,weak) IBOutlet UIButton *commitButton;
@property(nonatomic,weak) IBOutlet UIButton *iAgreeButton;
@property(nonatomic,weak) IBOutlet UIButton *agreeButton;
@property(nonatomic,weak) IBOutlet UIButton *sendCaptchaButton;
@property(nonatomic,weak) IBOutlet UISwitch *passwordSwith;

@property(nonatomic,weak) IBOutlet UILabel *counterLabel;

@property(nonatomic,strong) MSFAuthorizeViewModel *viewModel;

@end

@implementation MSFSignUpViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-login"]];
	self.username.text = MSFUtils.phone;
	if (NSProcessInfo.processInfo.environment[MSFAutoinputDebuggingEnvironmentKey] != nil) {
		self.username.text = @"18223959242";
	}
	self.viewModel = [[MSFAuthorizeViewModel alloc] init];
	RAC(self.viewModel,username) = self.username.rac_textSignal;
	RAC(self.viewModel,password) = self.password.rac_textSignal;
	RAC(self.viewModel,captcha) = self.captcha.rac_textSignal;
	RAC(self.counterLabel,text) = RACObserve(self.viewModel, counter);
	
	RAC(self.counterLabel,textColor) = [self.viewModel.captchaRequestValidSignal
		map:^id(NSNumber *valid) {
			return valid.boolValue ? UIColor.whiteColor : UIColor.lightGrayColor;
		}];
	self.iAgreeButton.rac_command = self.viewModel.executeAgreeOnLicense;
	self.agreeButton.rac_command	= self.viewModel.executeAgreeOnLicense;
	RAC(self.agreeButton,selected) = RACObserve(self.viewModel, agreeOnLicense);
	
	self.commitButton.rac_command = self.viewModel.executeSignUp;
	@weakify(self)
	[self.commitButton.rac_command.executionSignals subscribeNext:^(RACSignal *signUpSignal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在注册..." maskType:SVProgressHUDMaskTypeClear];
		[signUpSignal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			[self performSegueWithIdentifier:@"complement" sender:nil];
		}];
	}];
	
	[self.commitButton.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	[self.password.rac_keyboardReturnSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.viewModel.executeSignUp execute:nil];
	}];
	
	self.sendCaptchaButton.rac_command = self.viewModel.executeCaptcha;
	[self.sendCaptchaButton.rac_command.executionSignals subscribeNext:^(RACSignal *captchaSignal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在发送验证码" maskType:SVProgressHUDMaskTypeClear];
		[captchaSignal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
		}];
	}];
	[self.sendCaptchaButton.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	[self.passwordSwith.rac_newOnChannel subscribeNext:^(NSNumber *x) {
		@strongify(self)
		[self.password setSecureTextEntry:!x.boolValue];
	}];
}

@end
