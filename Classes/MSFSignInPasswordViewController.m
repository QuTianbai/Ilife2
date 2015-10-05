//
// MSFSignInPasswordViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSignInPasswordViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFAuthorizeViewModel.h"

@interface MSFSignInPasswordViewController ()

@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UITextField *usingField;
@property (nonatomic, weak) IBOutlet UITextField *updatingField;

@property (nonatomic, weak) IBOutlet UITextField *captcha;
@property (nonatomic, weak) IBOutlet UIButton *sendCaptchaButton;
@property (nonatomic, weak) IBOutlet UILabel *counterLabel;
@property (nonatomic, weak) IBOutlet UIImageView *sendCaptchaView;

@property (nonatomic, weak) IBOutlet UIButton *commitButton;

@end

@implementation MSFSignInPasswordViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	@weakify(self)
	RAC(self, counterLabel.text) = RACObserve(self, viewModel.counter);
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
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel =  viewModel;
}

@end
