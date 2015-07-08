//
//  MSFLoanAgreementWebView.m
//  Cash
//
//  Created by xbm on 15/6/4.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFLoanAgreementWebView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/EXTScope.h>
#import "MSFUtils.h"
#import "MSFAgreementViewModel.h"
#import "MSFApplyStartViewModel.h"
#import "MSFAFRequestViewModel.h"
#import "MSFProgressHUD.h"
#import "MSFApplyCash.h"
#import "MSFApplyInfo.h"

@interface MSFLoanAgreementWebView ()

@property(weak, nonatomic) IBOutlet UIWebView *LoanAgreenmentWV;
@property(nonatomic,strong) MSFApplyStartViewModel *viewModel;
@property(nonatomic,weak) IBOutlet UIButton *agreeButton;
@property(nonatomic,weak) IBOutlet UIButton *disAgreeButton;

@end

@implementation MSFLoanAgreementWebView

- (void)viewDidLoad {
  self.title = @"贷款协议";
	self.edgesForExtendedLayout = UIRectEdgeNone;
	RACSignal *signal = [MSFUtils.agreementViewModel loanAgreementSignalWithProduct:self.viewModel.requestViewModel.product];
  [self.LoanAgreenmentWV rac_liftSelector:@selector(loadHTMLString:baseURL:)
		withSignalOfArguments:[RACSignal combineLatest:@[signal,[RACSignal return:nil]]]];
	
	@weakify(self)
	self.agreeButton.rac_command = self.viewModel.requestViewModel.executeRequest;
	[self.viewModel.requestViewModel.executeRequest.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[MSFProgressHUD showStatusMessage:@"正在提交..." inView:self.navigationController.view];
		[signal subscribeNext:^(MSFApplyCash *applyCash) {
			[MSFProgressHUD hidden];
			self.viewModel.applyInfoModel.loanId = applyCash.applyID;
			self.viewModel.applyInfoModel.personId = applyCash.personId;
			self.viewModel.applyInfoModel.applyNo = applyCash.applyNo;
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Income" bundle:nil];
			UIViewController <MSFReactiveView> *vc = storyboard.instantiateInitialViewController;
			vc.hidesBottomBarWhenPushed = YES;
			[vc bindViewModel:self.viewModel];
			[self.navigationController pushViewController:vc animated:YES];
		}];
	}];
	[self.viewModel.requestViewModel.executeRequest.errors subscribeNext:^(NSError *error) {
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
