//
// MSFIDSignInViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFIDSignInViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFAuthorizeViewModel.h"
#import "UITextField+RACKeyboardSupport.h"
#import "MSFReactiveView.h"
#import "NSCharacterSet+MSFCharacterSetAdditions.h"

@interface MSFIDSignInViewController () <UITextFieldDelegate>

@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UITextField *name;
@property (nonatomic, weak) IBOutlet UITextField *card;
@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) IBOutlet UIButton *signInButton;

@end

@implementation MSFIDSignInViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
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
	[self.password.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		if ([x length] > MSFAuthorizePasswordMaxLength) self.password.text = [x substringToIndex:MSFAuthorizePasswordMaxLength];
		self.viewModel.password = self.password.text;
	}];

	self.signInButton.rac_command = self.viewModel.executeSignIn;
	[self.viewModel.executeSignIn.executionSignals subscribeNext:^(RACSignal *execution) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在登录..." maskType:SVProgressHUDMaskTypeClear];
		[execution subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFREQUESTCONTRACTSNOTIFACATION" object:nil];
			[self dismissViewControllerAnimated:YES completion:nil];
		}];
	}];
	
	[self.password.rac_keyboardReturnSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.viewModel.executeSignIn execute:nil];
	}];
	[self.viewModel.executeSignIn.errors subscribeNext:^(NSError *error) {
		@strongify(self)
		self.password.text = @"";
		self.viewModel.password = @"";
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	self.name.delegate = self;
	self.card.delegate = self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	[(id <MSFReactiveView>)segue.destinationViewController bindViewModel:self.viewModel];
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
	self.viewModel.loginType = MSFLoginIDSignIn;
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
