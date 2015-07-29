//
//	MSFLoanAgreementWebView.m
//	Cash
//
//	Created by xbm on 15/6/4.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFLoanAgreementController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFUtils.h"
#import "MSFAgreementViewModel.h"
#import "MSFProductViewModel.h"
#import "MSFApplicationResponse.h"
#import "MSFApplicationForms.h"
#import "MSFLoanAgreementViewModel.h"
#import "MSFPersonalViewModel.h"
#import "MSFAddressViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFAddress.h"

@interface MSFLoanAgreementController ()<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *LoanAgreenmentWV;
@property (nonatomic, strong) MSFLoanAgreementViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UIButton *agreeButton;
@property (nonatomic, weak) IBOutlet UIButton *disAgreeButton;
@property (nonatomic, weak) IBOutlet UIView *BottomBtVIew;

@end

@implementation MSFLoanAgreementController

- (void)viewDidLoad {
	self.title = @"贷款协议";
  self.LoanAgreenmentWV.delegate = self;
	self.edgesForExtendedLayout = UIRectEdgeNone;
	RACSignal *signal = [self.viewModel.agreementViewModel loanAgreementSignalWithProduct:self.viewModel.product];
	
	[SVProgressHUD showWithStatus:@"正在加载..."];
	[[[self.LoanAgreenmentWV
		rac_liftSelector:@selector(loadHTMLString:baseURL:)
		withSignalOfArguments:[RACSignal combineLatest:@[signal, [RACSignal return:nil]]]]
		deliverOn:[RACScheduler mainThreadScheduler]]
		subscribeNext:^(id x) {
		 [SVProgressHUD dismiss];
	 }
	 error:^(NSError *error) {
		 [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	 }];
	[[self rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(id x) {
		[SVProgressHUD dismiss];
	}];
	
	@weakify(self)
	self.agreeButton.rac_command = self.viewModel.executeRequest;
	[self.viewModel.executeRequest.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(MSFApplicationResponse *applyCash) {
			[SVProgressHUD dismiss];
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"personal" bundle:nil];
			UIViewController <MSFReactiveView> *vc = storyboard.instantiateInitialViewController;
			vc.hidesBottomBarWhenPushed = YES;
			MSFAddressViewModel *addressViewModel = [[MSFAddressViewModel alloc] initWithAddress:self.viewModel.formsViewModel.currentAddress services:self.viewModel.services];
			MSFPersonalViewModel *viewModel = [[MSFPersonalViewModel alloc] initWithFormsViewModel:self.viewModel.formsViewModel addressViewModel:addressViewModel];
			[vc bindViewModel:viewModel];
			[self.navigationController pushViewController:vc animated:YES];
		}];
	}];
	[self.viewModel.executeRequest.errors subscribeNext:^(NSError *error) {
		@strongify(self)
		//FIXME: 临时使用代码，错误的情况也进入个人信息
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"personal" bundle:nil];
    UIViewController <MSFReactiveView> *vc = storyboard.instantiateInitialViewController;
    vc.hidesBottomBarWhenPushed = YES;
		MSFAddressViewModel *addressViewModel = [[MSFAddressViewModel alloc] initWithAddress:self.viewModel.formsViewModel.currentAddress services:self.viewModel.services];
    MSFPersonalViewModel *viewModel = [[MSFPersonalViewModel alloc] initWithFormsViewModel:self.viewModel.formsViewModel addressViewModel:addressViewModel];
    [vc bindViewModel:viewModel];
    [self.navigationController pushViewController:vc animated:YES];
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	[[self.disAgreeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		[self.navigationController popViewControllerAnimated:YES];
	}];
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  self.BottomBtVIew.hidden = NO;
}

@end
