//
// MSFSignInViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSignInViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFAuthorizeViewModel.h"
#import "MSFSignInViewController.h"
#import "MSFUtils.h"
#import "UIColor+Utils.h"
#import "UITextField+RACKeyboardSupport.h"

static NSString *const MSFAutoinputDebuggingEnvironmentKey = @"INPUT_AUTO_DEBUG";

@interface MSFSignInViewController ()

@property (nonatomic, strong, readwrite) MSFAuthorizeViewModel *viewModel;

@end

@implementation MSFSignInViewController

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFSignInViewController `-dealloc`");
}

- (instancetype)initWithViewModel:(MSFAuthorizeViewModel *)viewModel {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"login" bundle:nil];
	self = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	[self bindViewModel:self.viewModel];
	
	return self;
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
  @weakify(self)
	[self.username.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.username = x;
	}];
	[self.password.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.password = x;
	}];
	
	self.signInButton.rac_command = self.viewModel.executeSignIn;
	[self.viewModel.executeSignIn.executionSignals subscribeNext:^(RACSignal *execution) {
		@strongify(self)
		[self.view endEditing:YES];
		[MSFUtils setPhone:self.username.text];
		[SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeClear];
		[execution subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			[self dismissViewControllerAnimated:YES completion:nil];
		}];
	}];
	[self.viewModel.executeSignIn.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	[self.password.rac_keyboardReturnSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.viewModel.executeSignIn execute:nil];
	}];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"登录";
	self.tableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
	self.edgesForExtendedLayout = UIRectEdgeNone;
	self.backgroundView.layer.masksToBounds = YES;
	self.backgroundView.layer.cornerRadius = 5;
	self.backgroundView.layer.borderColor = [UIColor borderColor].CGColor;
	self.backgroundView.layer.borderWidth = 1;
	
	self.username.text = MSFUtils.phone;
	if (NSProcessInfo.processInfo.environment[MSFAutoinputDebuggingEnvironmentKey] != nil) {
		self.username.text = @"18696995689";
		self.password.text = @"123456qw";
	}
}

@end
