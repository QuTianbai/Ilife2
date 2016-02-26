//
// MSFSignInViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSignInViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFAuthorizeViewModel.h"
#import "MSFSignInViewController.h"
#import "UITextField+RACKeyboardSupport.h"
#import "MSFActivate.h"

#import "MSFRepaymentPlanViewModel.h"
#import "MSFRepaymentPlanViewController.h"
#import "UIColor+Utils.h"
#import "MSFSignUpButton.h"
#import "UIImage+Color.h"
#import "MSFFindPasswordViewController.h"

static NSString *const MSFAutoinputDebuggingEnvironmentKey = @"INPUT_AUTO_DEBUG";
static NSString *const MSFAutoinputDebuggingPasswordEnvironmentKey = @"INPUT_AUTO_PASSWORD";
static NSString *const MSFAutoinputDebuggingUsernameEnvironmentKey = @"INPUT_AUTO_USERNAME";

@interface MSFSignInViewController ()

@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;
@property (weak, nonatomic) IBOutlet MSFSignUpButton *signUpBt;
@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) IBOutlet UIButton *signInButton;
@property (nonatomic, weak) IBOutlet UITextField *captcha;
@property (nonatomic, weak) IBOutlet UIButton *sendCaptchaButton;
@property (nonatomic, weak) IBOutlet UILabel *counterLabel;
@property (nonatomic, weak) IBOutlet UIImageView *sendCaptchaView;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBt;

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
	
	[[UINavigationBar appearance] setBarTintColor:UIColor.barTintColor];
	[[UINavigationBar appearance] setTintColor:UIColor.tintColor];
	[[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColor.tintColor}];
	
	self.tableView.backgroundColor = [UIColor navigationBgColor];
	self.edgesForExtendedLayout = UIRectEdgeNone;
	// 登录用户名/密码
	self.username.text = MSFActivate.signInMobile;
	self.viewModel.username = MSFActivate.signInMobile;

	if (NSProcessInfo.processInfo.environment[MSFAutoinputDebuggingEnvironmentKey] != nil) {
		self.username.text = NSProcessInfo.processInfo.environment[MSFAutoinputDebuggingUsernameEnvironmentKey];
		self.password.text = NSProcessInfo.processInfo.environment[MSFAutoinputDebuggingPasswordEnvironmentKey];
	}

	@weakify(self)
	self.signUpBt.rac_command = self.viewModel.executeSignUpCommand;
	[[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
		@strongify(self)
		self.navigationController.navigationBarHidden = YES;
		self.viewModel.username = self.username.text;
		self.viewModel.password = self.password.text;
		self.viewModel.loginType = MSFLoginSignIn;
	}];

	[self.username.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		if ([x length] > MSFAuthorizeUsernameMaxLength) self.username.text = [x substringToIndex:MSFAuthorizeUsernameMaxLength];
		self.viewModel.username = self.username.text;
	}];

	[self.password.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		if ([x length] > MSFAuthorizePasswordMaxLength) self.password.text = [x substringToIndex:MSFAuthorizePasswordMaxLength];
		self.viewModel.password = self.password.text;
	}];

	[self.captcha.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		if ([x length] > MSFAuthorizeCaptchaMaxLength) self.captcha.text = [x substringToIndex:MSFAuthorizeCaptchaMaxLength];
		self.viewModel.captcha = self.captcha.text;
	}];

	// 登录按钮
	self.signInButton.rac_command = self.viewModel.executeSignIn;
	[self.viewModel.executeSignIn.executionSignals subscribeNext:^(RACSignal *execution) {
		@strongify(self)
		[self.view endEditing:YES];
		[MSFActivate setSignInMobile:self.username.text];
		[SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeClear];
		[execution subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFREQUESTCONTRACTSNOTIFACATION" object:nil];
			[self dismissViewControllerAnimated:YES completion:nil];
		}];
	}];
	[self.viewModel.executeSignIn.errors subscribeNext:^(NSError *error) {
		@strongify(self)
		self.password.text = @"";
		self.viewModel.password = @"";
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];

	[self.password.rac_keyboardReturnSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.viewModel.executeSignIn execute:nil];
	}];
	[self.captcha.rac_keyboardReturnSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.viewModel.executeSignIn execute:nil];
	}];

	// 验证码
	[RACObserve(self.viewModel, counter) subscribeNext:^(id x) {
		@strongify(self)
		self.counterLabel.text = x;
	}];

	[self.viewModel.captchaRequestValidSignal subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.counterLabel.textColor = value.boolValue ? UIColor.whiteColor: [UIColor blackColor];
			self.sendCaptchaView.backgroundColor = value.boolValue ? [UIColor navigationBgColor] : [UIColor lightGrayColor];
//		self.sendCaptchaView.image = value.boolValue ? self.viewModel.captchaNomalImage : self.viewModel.captchaHighlightedImage;
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

	// 需要验证码的时候界面更新
	[self.viewModel.signInInvalidSignal subscribeNext:^(id x) {
		@strongify(self)
		self.password.returnKeyType = self.viewModel.signInValid ? UIReturnKeyJoin : UIReturnKeyDefault;
		[self.tableView reloadData];
	}];
	
//	[[self.forgetPasswordBt rac_signalForControlEvents:UIControlEventTouchUpInside]
//	subscribeNext:^(id x) {
//		MSFFindPasswordViewController *findPasswordVC = [[MSFFindPasswordViewController alloc] initWithModel:self.viewModel];
//		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:findPasswordVC];
//		[self presentModalViewController:navigationController animated:YES];
//		
//	}];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.viewModel.active = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.viewModel.active = NO;
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//	[segue.destinationViewController bindViewModel:self.viewModel];
//}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.viewModel.signInValid ? 2 : 3;
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
