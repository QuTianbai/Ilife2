//
// MSFSignUpViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSignUpViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <libextobjc/extobjc.h>
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
#import "MSFAuthorizeViewModel.h"
#import "MSFUtils.h"
#import "UIColor+Utils.h"
#import "UITextField+RACKeyboardSupport.h"
#import "MSFCommandView.h"
#import "MSFXBMCustomHeader.h"
#import "NSDate+UTC0800.h"
#import "NSDateFormatter+MSFFormattingAdditions.h"
#import "NSCharacterSet+MSFCharacterSetAdditions.h"


static NSString *const MSFAutoinputDebuggingEnvironmentKey = @"INPUT_AUTO_DEBUG";

@interface MSFSignUpViewController () <UITextFieldDelegate>

@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;

@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *captcha;
@property (nonatomic, weak) IBOutlet UITextField *password;

@property (nonatomic, weak) IBOutlet UIButton *commitButton;
@property (nonatomic, weak) IBOutlet UIButton *iAgreeButton;
@property (nonatomic, weak) IBOutlet UIButton *agreeButton;
@property (nonatomic, weak) IBOutlet UIButton *sendCaptchaButton;

@property (nonatomic, weak) IBOutlet UILabel *counterLabel;
@property (nonatomic, weak) IBOutlet UIButton *showPasswordButton;
@property (nonatomic, weak) IBOutlet UIImageView *sendCaptchaView;

@property (nonatomic, weak) IBOutlet UITextField *name;
@property (nonatomic, weak) IBOutlet UITextField *card;
@property (nonatomic, weak) IBOutlet UITextField *expired;
@property (nonatomic, weak) IBOutlet UIImageView *expiredView;
@property (nonatomic, weak) IBOutlet UIButton *permanentButton;
@property (nonatomic, weak) IBOutlet UIButton *datePickerButton;

@end

@implementation MSFSignUpViewController

@synthesize pageIndex;

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.tableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
	self.name.delegate = self;
	self.card.delegate = self;
	
	@weakify(self)
	[[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.username = self.username.text;
		self.viewModel.password = self.password.text;
		self.viewModel.loginType = MSFLoginSignUp;
	}];
	
	self.iAgreeButton.rac_command = self.viewModel.executeAgreeOnLicense;
	self.agreeButton.rac_command = self.viewModel.executeAgreeOnLicense;
	self.commitButton.rac_command = self.viewModel.executeSignUp;
	self.sendCaptchaButton.rac_command = self.viewModel.executeCaptcha;
	
	RAC(self, counterLabel.text) = RACObserve(self, viewModel.counter);
	RAC(self, agreeButton.selected) = [RACObserve(self, viewModel.agreeOnLicense) map:^id(id value) {
		return @([value boolValue]);
	}];
	
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
	
	[self.viewModel.captchaRequestValidSignal subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.counterLabel.textColor = value.boolValue ? UIColor.whiteColor: [UIColor blackColor];
		self.sendCaptchaView.image = value.boolValue ? self.viewModel.captchaNomalImage : self.viewModel.captchaHighlightedImage;
	}];
	
	[self.commitButton.rac_command.executionSignals subscribeNext:^(RACSignal *signUpSignal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在注册..." maskType:SVProgressHUDMaskTypeClear];
		[signUpSignal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
			[MSFUtils setRegisterPhone:@""]; 
		}];
	}];
	
	[self.commitButton.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	[self.password.rac_keyboardReturnSignal subscribeNext:^(id x) {
		@strongify(self)
		[self.viewModel.executeSignUp execute:nil];
	}];
	
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
	
	[[self.permanentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		self.viewModel.permanent = !self.viewModel.permanent;
		self.datePickerButton.enabled = !self.viewModel.permanent;
		if (self.viewModel.permanent) {
			self.expiredView.image = [UIImage imageNamed:@"bg-date-disable"];
			self.permanentButton.selected = YES;
			self.expired.text = @"";
		} else {
			self.expiredView.image = nil;
			self.permanentButton.selected = NO;
		}
	}];
	
	[[self.datePickerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		[self.view endEditing:YES];
		NSDate *maxDate = NSDate.max_date;
		NSDate *minDate = NSDate.msf_date;
		NSDate *date = self.viewModel.expired ?: NSDate.msf_date;
		[ActionSheetDatePicker showPickerWithTitle:@""
			datePickerMode:UIDatePickerModeDate
			selectedDate:date
			minimumDate:minDate
			maximumDate:maxDate
			doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
				self.expired.text = [NSDateFormatter msf_stringFromDate:[NSDate msf_date:selectedDate]];
				self.viewModel.expired = selectedDate;
			} cancelBlock:nil origin:self.view];
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
	self.viewModel = viewModel;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if ([textField isEqual:self.card]) {
		textField.text = [textField.text uppercaseString];
	}
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([textField isEqual:self.name]) {
		NSCharacterSet *blockedCharacters = [[NSCharacterSet letterCharacterSet] invertedSet];
    NSCharacterSet *blockedCharatersSquared = [NSCharacterSet characterSetWithCharactersInString:@"➋➌➍➎➏➐➑➒"];
		return ([string rangeOfCharacterFromSet:blockedCharacters].location == NSNotFound) || ([string rangeOfCharacterFromSet:blockedCharatersSquared].location != NSNotFound);
	} else if ([textField isEqual:self.card]) {
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
