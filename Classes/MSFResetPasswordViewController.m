//
// MSFResetPasswordViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFResetPasswordViewController.h"
#import "MSFAuthorizeViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MSFResetPasswordViewController ()

@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UITextField *firstTextField;
@property (nonatomic, weak) IBOutlet UITextField *secondTextField;
@property (nonatomic, weak) IBOutlet UIButton *commitButton;

@end

@implementation MSFResetPasswordViewController

- (instancetype)initWithViewModel:(id)viewModel {
  self = [[UIStoryboard storyboardWithName:@"login" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(MSFResetPasswordViewController.class)];
  if (!self) {
    return nil;
  }
	
	_viewModel = viewModel;
  
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	RAC(self, viewModel.password) = self.firstTextField.rac_textSignal;
	
	@weakify(self)
	[[self.commitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		if (self.viewModel.password.length < 8) {
			[SVProgressHUD showErrorWithStatus:@"请输入密码"];
			return;
		}
		if (![self.firstTextField.text isEqualToString:self.secondTextField.text]) {
			[SVProgressHUD showErrorWithStatus:@"请输入相同的密码"];
			return;
		}
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[[self.viewModel.executeFindPassword execute:nil] subscribeNext:^(id x) {
            self.viewModel.captcha = @"";
			[SVProgressHUD showSuccessWithStatus:@"重置密码成功，请重新登录"];
			[self.navigationController popToRootViewControllerAnimated:YES];
		}];
	}];
	[self.viewModel.executeFindPassword.errors subscribeNext:^(NSError *error) {
        self.viewModel.captcha = @"";
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
}

@end
