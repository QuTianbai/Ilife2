//
// MSFEditUserinfoViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFEditPasswordViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFUserViewModel.h"
#import "MSFUtils.h"
#import "UITextField+RACKeyboardSupport.h"

@interface MSFEditPasswordViewController ()

@property (nonatomic, weak) IBOutlet UITextField *passoword1;
@property (nonatomic, weak) IBOutlet UITextField *passoword2;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, weak) MSFUserViewModel *viewModel;

@property (nonatomic, weak) IBOutlet UIButton *password1Button;
@property (nonatomic, weak) IBOutlet UIButton *password2Button;

@end

@implementation MSFEditPasswordViewController

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"`dealloc`");
}

- (instancetype)initWithViewModel:(id)viewModel {
	self = [[UIStoryboard storyboardWithName:@"login" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(MSFEditPasswordViewController.class)];
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"修改密码";
	RAC(self.viewModel, usedPassword) = self.passoword1.rac_textSignal;
	RAC(self.viewModel, updatePassword) = self.passoword2.rac_textSignal;
	self.button.rac_command = self.viewModel.executeUpdatePassword;
	
	@weakify(self)
	[self.viewModel.executeUpdatePassword.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"密码更新成功"];
			[self.navigationController popViewControllerAnimated:YES];
		}];
	}];
	[self.viewModel.executeUpdatePassword.errors subscribeNext:^(NSError *error) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	[self.passoword2.rac_keyboardReturnSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.viewModel.executeUpdatePassword execute:nil];
	}];
	
	self.passoword1.clearButtonMode = UITextFieldViewModeNever;
	self.passoword2.clearButtonMode = UITextFieldViewModeNever;
	
	[[self.password1Button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(NSNumber *x) {
		@strongify(self)
		self.password1Button.selected = !self.password1Button.selected;
		NSString *text = self.passoword1.text;
		self.passoword1.text = text;
		self.passoword1.enabled = NO;
		[self.passoword1 setSecureTextEntry:!self.password1Button.selected];
		self.passoword1.enabled = YES;
		[self.passoword1 becomeFirstResponder];
	}];
	[[self.password2Button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(NSNumber *x) {
		@strongify(self)
		self.password2Button.selected = !self.password2Button.selected;
		NSString *text = self.passoword2.text;
		self.passoword2.text = text;
		self.passoword2.enabled = NO;
		[self.passoword2 setSecureTextEntry:!self.password2Button.selected];
		self.passoword2.enabled = YES;
		[self.passoword2 becomeFirstResponder];
	}];
}

@end
