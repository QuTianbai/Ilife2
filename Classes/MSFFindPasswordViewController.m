//
// MSFFindPasswordViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFFindPasswordViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFAuthorizeViewModel.h"
#import "UITextField+RACKeyboardSupport.h"
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"
#import "UIColor+Utils.h"
#import "MSFActivate.h"
#import "NSCharacterSet+MSFCharacterSetAdditions.h"
#import "UIImage+Color.h"
#import "MSFResetPasswordViewController.h"

@interface MSFFindPasswordViewController () <UITextFieldDelegate>

@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;

@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *captcha;
@property (nonatomic, weak) IBOutlet UIButton *captchaButton;
@property (nonatomic, weak) IBOutlet UIButton *commitButton;
@property (nonatomic, weak) IBOutlet UIImageView *sendCaptchaView;
@property (nonatomic, weak) IBOutlet UILabel *counterLabel;

@end

@implementation MSFFindPasswordViewController

- (instancetype)initWithModel:(id)viewModel {
	self = [[UIStoryboard storyboardWithName:@"login" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(MSFFindPasswordViewController.class)];
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"忘记密码";
	self.navigationController.navigationBarHidden = NO;
	self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor;
	
	self.username.text = MSFActivate.signInMobile;
	self.viewModel.username = MSFActivate.signInMobile;
	
	@weakify(self)
	[self.username.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		if ([x length] > MSFAuthorizeUsernameMaxLength) self.username.text = [x substringToIndex:MSFAuthorizeUsernameMaxLength];
		self.viewModel.username = self.username.text;
	}];
	
	[self.captcha.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		if ([x length] > MSFAuthorizeCaptchaMaxLength) self.captcha.text = [x substringToIndex:MSFAuthorizeCaptchaMaxLength];
		self.viewModel.captcha = self.captcha.text;
	}];
	
	RAC(self.counterLabel, text) = RACObserve(self.viewModel, counter);
	
	[self.viewModel.captchaRequestValidSignal subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.counterLabel.textColor = value.boolValue ? UIColor.whiteColor: [UIColor blackColor];
		self.sendCaptchaView.backgroundColor = value.boolValue ? [UIColor navigationBgColor] : [UIColor lightGrayColor];
	}];
	
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
	
	[[self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		if (self.captcha.text.length != 4) {
			[SVProgressHUD showErrorWithStatus:@"请输入正确的验证码"];
			return;
		}
		MSFResetPasswordViewController *vc = [[MSFResetPasswordViewController alloc] initWithViewModel:self.viewModel];
		[self.navigationController pushViewController:vc animated:YES];
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.viewModel.active = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.viewModel.active = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[segue.destinationViewController bindViewModel:self.viewModel];
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end