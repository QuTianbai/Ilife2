//
// MSFPaymentViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFTransactionsViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "RVMViewModel.h"

@interface MSFTransactionsViewController ()

@property (nonatomic, strong) RVMViewModel <MSFTransactionsViewModel> *viewModel;

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

@implementation MSFTransactionsViewController

- (instancetype)initWithViewModel:(id)viewModel {
  self = [[UIStoryboard storyboardWithName:NSStringFromClass([MSFTransactionsViewController class]) bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFTransactionsViewController class])];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
	
  return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	RAC(self.bankName, text) = RACObserve(self.viewModel, bankName);
	RAC(self.bankNo, text) = RACObserve(self.viewModel, bankNo);
	RAC(self.bankIco, image) = [RACObserve(self.viewModel, bankIco) map:^id(id value) {
		return [UIImage imageNamed:value];
	}];
	RAC(self.payment, text) = RACObserve(self.viewModel, summary);
	RAC(self.amount, text) = RACObserve(self.viewModel, amounts);
	RAC(self.supports, text) = RACObserve(self.viewModel, supports);
	RAC(self.amount, userInteractionEnabled) = RACObserve(self.viewModel, editable);
	
	RAC(self.viewModel, captcha) = self.authCode.rac_textSignal;
	
	self.fetchAuthcode.rac_command = self.viewModel.executeCaptchaCommand;
	
	@weakify(self)
	[RACObserve(self.viewModel, captchaTitle) subscribeNext:^(id x) {
		@strongify(self)
		[self.fetchAuthcode setTitle:x forState:UIControlStateNormal];
	}];
	
	[self.viewModel.executeCaptchaCommand.executionSignals subscribeNext:^(id x) {
		@strongify(self)
		[self.authCode becomeFirstResponder];
	}];
	[self.viewModel.executeCaptchaCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	self.checkOut.rac_command = self.viewModel.executePaymentCommand;
	[self.viewModel.executePaymentCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	[self.viewModel.executePaymentCommand.executionSignals subscribeNext:^(id x) {
		[x subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"交易成功"];
			[self.navigationController popViewControllerAnimated:YES];
		}];
	}];
	
	self.changeCard.rac_command = self.viewModel.executeSwitchCommand;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.viewModel.active = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.viewModel.active = NO;
}

@end
