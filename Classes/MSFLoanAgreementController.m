//
//  MSFLoanAgreementWebView.m
//  Cash
//
//  Created by xbm on 15/6/4.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFLoanAgreementController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "MSFUtils.h"
#import "MSFAgreementViewModel.h"
#import "MSFApplyStartViewModel.h"
#import "MSFProductViewModel.h"
#import "MSFProgressHUD.h"
#import "MSFApplyCash.h"
#import "MSFApplyInfo.h"
#import "MSFLoanAgreementViewModel.h"
#import "MSFPersonalViewModel.h"

@interface MSFLoanAgreementController ()

@property(weak, nonatomic) IBOutlet UIWebView *LoanAgreenmentWV;
@property(nonatomic,strong) MSFLoanAgreementViewModel *viewModel;
@property(nonatomic,weak) IBOutlet UIButton *agreeButton;
@property(nonatomic,weak) IBOutlet UIButton *disAgreeButton;

@end

@implementation MSFLoanAgreementController

- (void)viewDidLoad {
  self.title = @"贷款协议";
	self.edgesForExtendedLayout = UIRectEdgeNone;
	RACSignal *signal = [MSFUtils.agreementViewModel loanAgreementSignalWithProduct:self.viewModel.product];
  [self.LoanAgreenmentWV rac_liftSelector:@selector(loadHTMLString:baseURL:)
		withSignalOfArguments:[RACSignal combineLatest:@[signal,[RACSignal return:nil]]]];
	
	@weakify(self)
	self.agreeButton.rac_command = self.viewModel.executeRequest;
	[self.viewModel.executeRequest.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[MSFProgressHUD showStatusMessage:@"正在提交..." inView:self.navigationController.view];
		[signal subscribeNext:^(MSFApplyCash *applyCash) {
			[MSFProgressHUD hidden];
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"personal" bundle:nil];
			UIViewController <MSFReactiveView> *vc = storyboard.instantiateInitialViewController;
			vc.hidesBottomBarWhenPushed = YES;
			MSFPersonalViewModel *viewModel = [[MSFPersonalViewModel alloc] initWithFormsViewModel:self.viewModel.formsViewModel];
			[vc bindViewModel:viewModel];
			[self.navigationController pushViewController:vc animated:YES];
		}];
	}];
	[self.viewModel.executeRequest.errors subscribeNext:^(NSError *error) {
		@strongify(self)
		[MSFProgressHUD showErrorMessage:error.userInfo[NSLocalizedFailureReasonErrorKey] inView:self.navigationController.view];
	}];
	[[self.disAgreeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		[self.navigationController popViewControllerAnimated:YES];
	}];
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
