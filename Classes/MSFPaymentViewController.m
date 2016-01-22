//
// MSFPaymentViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFPaymentViewController.h"
//#import "MSFPaymentViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface MSFPaymentViewController ()

@property (nonatomic, strong) NSObject <MSFPaymentViewModel> *viewModel;

@property (nonatomic, weak) IBOutlet UILabel *bankName;
@property (nonatomic, weak) IBOutlet UILabel *bankNo;
@property (nonatomic, weak) IBOutlet UIImageView *bankIco;
@property (nonatomic, weak) IBOutlet UILabel *payment;
@property (nonatomic, weak) IBOutlet UITextField *amount;
@property (nonatomic, weak) IBOutlet UITextField *authCode;
@property (nonatomic, weak) IBOutlet UILabel *supports;
@property (nonatomic, weak) IBOutlet UIButton *changeCard;
@property (nonatomic, weak) IBOutlet UIButton *checkOut;
@property (nonatomic, weak) IBOutlet UIButton *fetchAuthcode;

@end

@implementation MSFPaymentViewController

- (instancetype)initWithViewModel:(id)viewModel {
  self = [[UIStoryboard storyboardWithName:NSStringFromClass([MSFPaymentViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFPaymentViewController class])];
  if (!self) {
    return nil;
  }
//	_viewModel = viewModel;
	
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	/*
	RAC(self.bankName, text) = RACObserve(self.viewModel, bankName);
	RAC(self.bankNo, text) = RACObserve(self.viewModel, bankCardNO);
	RAC(self.bankIco, image) = [RACObserve(self.viewModel, bankIcon) map:^id(id value) {
		return [UIImage imageNamed:value];
	}];
	RAC(self.payment, text) = RACObserve(self.viewModel, money);
	RAC(self.amount, text) = RACObserve(self.viewModel, drawCash);
	RAC(self.supports, text) = RACObserve(self.viewModel, supports);
	RAC(self.amount, userInteractionEnabled) = RACObserve(self.viewModel, editable);
	
	RAC(self.viewModel, smsCode) = self.authCode.rac_textSignal;
	
	self.fetchAuthcode.rac_command = self.viewModel.executeCaptchaComamnd;
	
	@weakify(self)
	[RACObserve(self.viewModel, captchaButtonTitle) subscribeNext:^(id x) {
		@strongify(self)
		[self.fetchAuthcode setTitle:x forState:UIControlStateNormal];
	}];
	
	[self.viewModel.executeCaptchaComamnd.executionSignals subscribeNext:^(id x) {
		@strongify(self)
		[self.authCode becomeFirstResponder];
	}];
	[self.viewModel.executeCaptchaComamnd.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	self.checkOut.rac_command = self.viewModel.executePaymentCommand;
	[self.viewModel.executePaymentCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	*/
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//	self.viewModel.active = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

@end
