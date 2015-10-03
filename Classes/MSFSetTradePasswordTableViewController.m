//
//  MSFSetTradePasswordTableViewController.m
//  Finance
//
//  Created by xbm on 15/10/3.
//  Copyright © 2015年 MSFINANCE. All rights reserved.
//

#import "MSFSetTradePasswordTableViewController.h"
#import "MSFSetTradePasswordViewModel.h"
#import "MSFCodeButton.h"
#import "MSFEdgeButton.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFAuthorizeViewModel.h"

@interface MSFSetTradePasswordTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tradePasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *sureTradePasswordTF;

@property (weak, nonatomic) IBOutlet UITextField *checkCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *checkCodeBT;
@property (weak, nonatomic) IBOutlet UILabel *countLB;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *sureBT;

//@property (nonatomic, strong) MSFSetTradePasswordViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UIImageView *sendCaptchaView;

@property (nonatomic, strong) MSFAuthorizeViewModel *viewModel;

@end

@implementation MSFSetTradePasswordTableViewController

- (instancetype)initWithViewModel:(id)viewModel {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"SetTradePassword" bundle:nil];
	self = storyboard.instantiateInitialViewController;
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	RAC(self, viewModel.TradePassword) = self.tradePasswordTF.rac_textSignal;
	RAC(self, viewModel.smsCode) = self.checkCodeTF.rac_textSignal;
	RAC(self, viewModel.againTradePWD) = self.sureTradePasswordTF.rac_textSignal;
	
	self.checkCodeBT.rac_command = self.viewModel.executeCaptcha;
	
	RAC(self, countLB.text) = RACObserve(self, viewModel.counter);
	
	@weakify(self)
	[self.checkCodeBT.rac_command.executionSignals subscribeNext:^(RACSignal *captchaSignal) {
		@strongify(self)
		[self.view endEditing:YES];
		[SVProgressHUD showWithStatus:@"正在获取验证码" maskType:SVProgressHUDMaskTypeClear];
		[captchaSignal subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
		}];
	}];
	
	[self.checkCodeBT.rac_command.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	
	[self.viewModel.captchaRequestValidSignal subscribeNext:^(NSNumber *value) {
		@strongify(self)
		self.countLB.textColor = value.boolValue ? UIColor.whiteColor: [UIColor blackColor];
		self.sendCaptchaView.image = value.boolValue ? self.viewModel.captchaNomalImage : self.viewModel.captchaHighlightedImage;
	}];

	self.sureBT.rac_command = self.viewModel.executeSetTradePwd;
	
	[self.viewModel.executeSetTradePwd.executionSignals subscribeNext:^(RACSignal *signal) {
		[signal subscribeNext:^(id x) {
			[SVProgressHUD showSuccessWithStatus:@"提交成功"];
			[self.navigationController popViewControllerAnimated:YES];
		}];
	}];
	
	[self.viewModel.executeSetTradePwd.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

@end
