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

@interface MSFLoanAgreementController ()

@property (nonatomic, weak) IBOutlet UIWebView *LoanAgreenmentWV;
@property (nonatomic, strong) MSFLoanAgreementViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UIButton *agreeButton;
@property (nonatomic, weak) IBOutlet UIButton *disAgreeButton;

@end

@implementation MSFLoanAgreementController

- (void)viewDidLoad {
  self.title = @"贷款协议";
	self.edgesForExtendedLayout = UIRectEdgeNone;
	RACSignal *signal = [MSFUtils.agreementViewModel loanAgreementSignalWithProduct:self.viewModel.product];
  
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
		[SVProgressHUD showWithStatus:@"正在提交..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(MSFApplicationResponse *applyCash) {
			[SVProgressHUD dismiss];
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"personal" bundle:nil];
			UIViewController <MSFReactiveView> *vc = storyboard.instantiateInitialViewController;
			vc.hidesBottomBarWhenPushed = YES;
			MSFAddressViewModel *addressViewModel = [[MSFAddressViewModel alloc] initWithApplicationForm:self.viewModel.formsViewModel.model controller:vc];
			MSFPersonalViewModel *viewModel = [[MSFPersonalViewModel alloc] initWithFormsViewModel:self.viewModel.formsViewModel addressViewModel:addressViewModel];
			[vc bindViewModel:viewModel];
			[self.navigationController pushViewController:vc animated:YES];
		}];
	}];
	[self.viewModel.executeRequest.errors subscribeNext:^(NSError *error) {
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

@end
