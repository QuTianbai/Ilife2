//
// MSFSignInPasswordViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSignInPhoneViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFAuthorizeViewModel.h"
#import "NSCharacterSet+MSFCharacterSetAdditions.h"

@interface MSFSignInPhoneViewController () <UITextFieldDelegate>

@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UITextField *usingField;
@property (nonatomic, weak) IBOutlet UITextField *updatingField;

@property (nonatomic, weak) IBOutlet UITextField *captcha;
@property (nonatomic, weak) IBOutlet UIButton *sendCaptchaButton;
@property (nonatomic, weak) IBOutlet UILabel *counterLabel;
@property (nonatomic, weak) IBOutlet UIImageView *sendCaptchaView;

@property (nonatomic, weak) IBOutlet UITextField *citizenID;
@property (nonatomic, weak) IBOutlet UITextField *name;

@property (nonatomic, weak) IBOutlet UIButton *commitButton;

@end

@implementation MSFSignInPhoneViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.citizenID.delegate = self;
	self.name.delegate = self;
	
	@weakify(self)
	RAC(self, counterLabel.text) = RACObserve(self, viewModel.counter);
	RAC(self, citizenID.text) = RACObserve(self, viewModel.card);
	RAC(self, name.text) = RACObserve(self, viewModel.name);
	
	RAC(self.name, text) = [[[self.name.rac_textSignal
		map:^id(NSString *value) {
			return [value stringByTrimmingCharactersInSet:[[NSCharacterSet chineseCharacterSet] invertedSet]];
		}]
		map:^id(NSString *value) {
			if (value.length > MSFAuthorizeNameMaxLength) {
				return [value substringToIndex:MSFAuthorizeNameMaxLength];
			} else {
				return value;
			}
		}]
		doNext:^(id x) {
			@strongify(self)
			self.viewModel.name = x;
		}];
	
	[self.citizenID.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		if ([x length] > MSFAuthorizeIdentifierMaxLength) self.citizenID.text = [x substringToIndex:MSFAuthorizeIdentifierMaxLength];
		self.viewModel.card = self.citizenID.text;
	}];
	
	[self.captcha.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		if ([x length] > MSFAuthorizeCaptchaMaxLength) self.captcha.text = [x substringToIndex:MSFAuthorizeCaptchaMaxLength];
		self.viewModel.captcha = self.captcha.text;
	}];
	
	[self.usingField.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		if ([x length] > MSFAuthorizeUsernameMaxLength) self.usingField.text = [x substringToIndex:MSFAuthorizeUsernameMaxLength];
		self.viewModel.usingMobile = self.usingField.text;
	}];
	
	[self.updatingField.rac_textSignal subscribeNext:^(id x) {
		@strongify(self)
		if ([x length] > MSFAuthorizeUsernameMaxLength) self.updatingField.text = [x substringToIndex:MSFAuthorizeUsernameMaxLength];
		self.viewModel.updatingMobile = self.updatingField.text;
	}];
	
	[self.viewModel.captchaRequestValidSignal subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.counterLabel.textColor = value.boolValue ? UIColor.whiteColor: [UIColor blackColor];
		self.sendCaptchaView.image = value.boolValue ? self.viewModel.captchaNomalImage : self.viewModel.captchaHighlightedImage;
	}];
	
	self.sendCaptchaButton.rac_command = self.viewModel.executeCaptchaAlterMobile;
	
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
	
	self.commitButton.rac_command = self.viewModel.executeAlterMobile;
	[self.viewModel.executeAlterMobile.executionSignals subscribeNext:^(RACSignal *signal) {
		[SVProgressHUD showSuccessWithStatus:@"正在提交..."];
		[signal subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"修改成功"];
		}];
	}];
	[self.viewModel.executeAlterMobile.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
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

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel =  viewModel;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([textField isEqual:self.citizenID]) {
		textField.text = [textField.text uppercaseString];
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([textField isEqual:self.name]) {
		NSCharacterSet *blockedCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
    NSCharacterSet *blockedCharatersSquared = [NSCharacterSet characterSetWithCharactersInString:@"➋➌➍➎➏➐➑➒"];
		return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound) || ([string rangeOfCharacterFromSet:blockedCharatersSquared].location != NSNotFound);
	} else if ([textField isEqual:self.citizenID]) {
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
