//
// MSFEditUserinfoViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFEditPasswordViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFUserViewModel.h"
#import "UITextField+RACKeyboardSupport.h"
#import "MSFAuthorizeViewModel.h"

@interface MSFEditPasswordViewController ()

@property (nonatomic, weak) IBOutlet UITextField *passoword1;
@property (nonatomic, weak) IBOutlet UITextField *passoword2;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;

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
	RAC(self, viewModel.usingSignInPasssword) = [self.passoword1.rac_textSignal map:^id(NSString *value) {
		NSString *tempStr = value.length > 16 ? [value substringToIndex:16] : value;
		self.passoword1.text = tempStr;
		return tempStr;
	}];
	RAC(self, viewModel.updatingSignInPasssword) = [self.passoword2.rac_textSignal map:^id(NSString *value) {
		NSString *tempStr = value.length > 16 ? [value substringToIndex:16] : value;
		self.passoword2.text = tempStr;
		return tempStr;
	}];
	self.button.rac_command = self.viewModel.executeUpdateSignInPassword;
	
	@weakify(self)
	[self.viewModel.executeUpdateSignInPassword.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeCompleted:^{
			[SVProgressHUD showSuccessWithStatus:@"密码更新成功, 请重新登录。"];
		}];
	}];
	[self.viewModel.executeUpdateSignInPassword.errors subscribeNext:^(NSError *error) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	[self.passoword2.rac_keyboardReturnSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.viewModel.executeUpdateSignInPassword execute:nil];
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

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
