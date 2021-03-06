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
#import "AppDelegate.h"
#import "MSFUser.h"
#import "MSFClient.h"

@interface MSFSetTradePasswordTableViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tradePasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *sureTradePasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *checkCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *checkCodeBT;
@property (weak, nonatomic) IBOutlet UILabel *countLB;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *sureBT;
@property (weak, nonatomic) IBOutlet UIImageView *sendCaptchaView;
@property (nonatomic, strong) MSFAuthorizeViewModel *viewModel;
@property (nonatomic, assign) NSInteger statusHash;

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
	self.title = @"设置交易密码";
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	_viewModel = appdelegate.authorizeVewModel;
	_statusHash = 0;
	[[self.tradePasswordTF rac_signalForControlEvents:UIControlEventEditingChanged]
	subscribeNext:^(UITextField *textField) {
		_statusHash = 1;
		if (textField.text.length > 6) {
			textField.text = [textField.text substringToIndex:6];
		}
	}];
	RAC(self, viewModel.TradePassword) = self.tradePasswordTF.rac_textSignal;
	[[self.checkCodeTF rac_signalForControlEvents:UIControlEventEditingChanged]
	subscribeNext:^(UITextField *textField) {
		_statusHash = 1;
		if (textField.text.length > 4) {
			textField.text = [textField.text substringToIndex:4];
		}
	}];
	RAC(self, viewModel.smsCode) = self.checkCodeTF.rac_textSignal;
	[[self.sureTradePasswordTF rac_signalForControlEvents:UIControlEventEditingChanged]
	subscribeNext:^(UITextField *textField) {
		_statusHash = 1;
		if (textField.text.length > 6) {
			textField.text = [textField.text substringToIndex:6];
		}
	}];
	RAC(self, viewModel.againTradePWD) = self.sureTradePasswordTF.rac_textSignal;
	
	
	self.checkCodeBT.rac_command = self.viewModel.executeCapthaTradePwd;
	
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
		[SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(id x) {
			//!!!: 设置交易密码后应该再次获取用户信息，以确保服务器是否更新了用户的交易密码
			MSFUser *user = [[MSFUser alloc] initWithDictionary:@{@"hasTransactionalCode": @YES} error:nil];
			[[self.viewModel.services httpClient].user mergeValueForKey:@"hasTransactionalCode" fromModel:user];
			[SVProgressHUD showSuccessWithStatus:@"设置交易密码成功"];
			[self.navigationController popViewControllerAnimated:YES];
		} error:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];

	}];
	
	[self.viewModel.executeSetTradePwd.errors subscribeNext:^(NSError *error) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 15;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

- (void)back {
	if (_statusHash == 0) {
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}
	
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认放弃设置交易密码？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	[alertView.rac_buttonClickedSignal subscribeNext:^(id x) {
		if ([x integerValue] == 1) {
			[self.navigationController popViewControllerAnimated:YES];
		}
	}];
	[alertView show];
	
}

@end
