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
#import "UIColor+Utils.h"
#import "UITextField+RACKeyboardSupport.h"
#import "MSFClozeViewModel.h"
#import "MSFClozeViewController.h"

static NSString *const MSFAutoinputDebuggingEnvironmentKey = @"INPUT_AUTO_DEBUG";

@interface MSFSignUpViewController ()

@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;

@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *captcha;
@property (nonatomic, weak) IBOutlet UITextField *password;

@property (nonatomic, weak) IBOutlet UIButton *commitButton;
@property (nonatomic, weak) IBOutlet UIButton *iAgreeButton;
@property (nonatomic, weak) IBOutlet UIButton *agreeButton;
@property (nonatomic, weak) IBOutlet UIButton *sendCaptchaButton;
@property (nonatomic, weak) IBOutlet UIView *backgroundView;

@property (nonatomic, weak) IBOutlet UILabel *counterLabel;

@end

@implementation MSFSignUpViewController

@synthesize pageIndex;

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
	self.backgroundView.layer.masksToBounds = YES;
	self.backgroundView.layer.cornerRadius = 5;
	self.backgroundView.layer.borderColor = [UIColor borderColor].CGColor;
	self.backgroundView.layer.borderWidth = 1;
	self.username.text = MSFUtils.phone;
	if (NSProcessInfo.processInfo.environment[MSFAutoinputDebuggingEnvironmentKey] != nil) {
		self.username.text = @"18223959242";
	}
	
	@weakify(self)
	[[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.username = self.username.text;
		self.viewModel.password = self.password.text;
	}];
	[self.username.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.username = x;
	}];
	[self.password.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.password = x;
	}];
	[self.captcha.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.captcha = x;
	}];
	[RACObserve(self.viewModel, counter) subscribeNext:^(id x) {
		@strongify(self)
		self.counterLabel.text = x;
	}];
	[RACObserve(self.viewModel, agreeOnLicense) subscribeNext:^(id x) {
		@strongify(self)
		self.agreeButton.selected = [x boolValue];
	}];
	
	[self.viewModel.captchaRequestValidSignal subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.counterLabel.textColor = value.boolValue ? UIColor.darkGrayColor: UIColor.lightGrayColor;
	}];
	
	self.iAgreeButton.rac_command = self.viewModel.executeAgreeOnLicense;
	self.agreeButton.rac_command = self.viewModel.executeAgreeOnLicense;
	RAC(self.agreeButton, selected) = RACObserve(self.viewModel, agreeOnLicense);
	
	self.commitButton.rac_command = self.viewModel.executeSignUp;
	[self.commitButton.rac_command.executionSignals subscribeNext:^(RACSignal *signUpSignal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在注册..." maskType:SVProgressHUDMaskTypeClear];
		[signUpSignal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			MSFClozeViewModel *viewModel = [[MSFClozeViewModel alloc] initWithServices:self.viewModel.services];
			MSFClozeViewController *clozeViewController = [[MSFClozeViewController alloc] initWithViewModel:viewModel];
			[self.navigationController pushViewController:clozeViewController animated:YES];
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
		[SVProgressHUD showWithStatus:@"正在获取验证码" maskType:SVProgressHUDMaskTypeClear];
		[captchaSignal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
		}];
	}];
	[self.sendCaptchaButton.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
