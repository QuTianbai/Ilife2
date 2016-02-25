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

@interface MSFFindPasswordViewController () <UITextFieldDelegate>

@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;

@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *captcha;
@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) IBOutlet UITextField *name;
@property (nonatomic, weak) IBOutlet UITextField *card;
@property (nonatomic, weak) IBOutlet UIButton *captchaButton;
@property (nonatomic, weak) IBOutlet UIButton *commitButton;
@property (nonatomic, weak) IBOutlet UIButton *showPasswordButton;
@property (nonatomic, weak) IBOutlet UIImageView *sendCaptchaView;
@property (nonatomic, weak) IBOutlet UILabel *counterLabel;

@end

@implementation MSFFindPasswordViewController

- (instancetype)initWithModel:(id)viewModel {
	self = [[UIStoryboard storyboardWithName:@"login" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass(self.class)];
	if (!self) {
		return nil;
	}
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"忘记密码";
	self.navigationController.navigationBarHidden = NO;
	
<<<<<<< HEAD

	self.username.text = MSFUtils.signInMobile;
	self.viewModel.username = MSFUtils.signInMobile;
=======
	self.username.text = MSFActivate.signInMobile;
	self.viewModel.username = MSFActivate.signInMobile;
>>>>>>> 149fcd287b84976e618cbb9226b1003e5d6c6748
	
	self.name.delegate = self;
	self.card.delegate = self;
	
	@weakify(self)
	[self.name.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		if ([x length] > MSFAuthorizeNameMaxLength) self.name.text = [x substringToIndex:MSFAuthorizeNameMaxLength];
		self.viewModel.name = self.name.text;
	}];
	
	[self.card.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		if ([x length] > MSFAuthorizeIdentifierMaxLength) self.card.text = [x substringToIndex:MSFAuthorizeIdentifierMaxLength];
		self.viewModel.card = self.card.text;
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
	
	self.commitButton.rac_command = self.viewModel.executeFindPassword;
	[self.commitButton.rac_command.executionSignals subscribeNext:^(RACSignal *signUpSignal) {
		@strongify(self)
		[MSFActivate setSignInMobile:self.username.text];
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[signUpSignal subscribeCompleted:^{
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

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	//self.navigationController.navigationBarHidden = NO;

	self.viewModel.active = YES;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([textField isEqual:self.card]) {
		textField.text = [textField.text uppercaseString];
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([textField isEqual:self.card]) {
		if (range.location > 17) return NO;
		if (range.location == 17) {
			NSCharacterSet *blockedCharacters = [[NSCharacterSet identifyCardCharacterSet] invertedSet];
			return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
		}
		NSCharacterSet *blockedCharacters = [[NSCharacterSet numberCharacterSet] invertedSet];
		return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound);
	}
	
	return YES;
}

@end