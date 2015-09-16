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
#import "MSFCustomAlertView.h"


static NSString *const MSFAutoinputDebuggingEnvironmentKey = @"INPUT_AUTO_DEBUG";
static NSString *const MSFAutoinputDebuggingPasswordEnvironmentKey = @"INPUT_AUTO_PASSWORD";

@interface MSFSignInViewController ()

@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;

@end

@implementation MSFSignInViewController

@synthesize pageIndex;

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFSignInViewController `-dealloc`");
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
		self.username.text = NSProcessInfo.processInfo.environment[MSFAutoinputDebuggingEnvironmentKey];
		self.password.text = NSProcessInfo.processInfo.environment[MSFAutoinputDebuggingPasswordEnvironmentKey];
	}
	@weakify(self)
	[[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.username = self.username.text;
		self.viewModel.password = self.password.text;
	}];
	[self.username.rac_textSignal subscribeNext:^(NSString *value) {
		@strongify(self)
		if (value.length > 11) {
			value = [value substringToIndex:11];
			self.username.text = value;
		}
		
		self.viewModel.username = value;
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
			[[NSNotificationCenter defaultCenter] postNotificationName:MSFREQUESTCONTRACTSNOTIFACATION object:nil];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[segue.destinationViewController bindViewModel:self.viewModel];
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
