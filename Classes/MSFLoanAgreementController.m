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
#import "MSFApplicationResponse.h"
#import "MSFApplicationForms.h"
#import "MSFLoanAgreementViewModel.h"
#import "MSFPersonalViewModel.h"
#import "MSFAddressViewModel.h"
#import "MSFFormsViewModel.h"
#import "MSFAddress.h"

#import "MSFSubmitApplyModel.h"
#import "MSFUserInfomationViewController.h"

#import "MSFEdgeButton.h"

@interface MSFLoanAgreementController ()<UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *LoanAgreenmentWV;
@property (nonatomic, strong) MSFLoanAgreementViewModel *viewModel;
@property (weak, nonatomic) IBOutlet MSFEdgeButton *submitButton;

@end

@implementation MSFLoanAgreementController

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFLoanAgreementController dealloc");
}

- (instancetype)initWithViewModel:(id)viewModel {
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"product" bundle:nil];
	self =  [storyboard instantiateViewControllerWithIdentifier:@"MSFLoanAgreementWebView"];
  if (!self) {
    return nil;
  }
	_viewModel = viewModel;
  
  return self;
}

- (void)viewDidLoad {
	self.title = @"贷款协议";
  self.LoanAgreenmentWV.delegate = self;
	self.edgesForExtendedLayout = UIRectEdgeNone;
	RACSignal *signal = [self.viewModel.agreementViewModel loanAgreementSignalWithViewModel:self.viewModel.formsViewModel];
	[self.LoanAgreenmentWV stringByEvaluatingJavaScriptFromString:@"var script = document.createElement('script');"
	 "script.type = 'text/javascript';"
	 "script.text = \"function confirm() { "
	 "window.location.href ='objc';"
	 "}\";"
	 "document.getElementsByTagName('head')[0].appendChild(script);"];
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
	self.submitButton.rac_command = self.viewModel.executeRequest;
	@weakify(self)
	[self.viewModel.executeRequest.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
		[signal subscribeNext:^(MSFSubmitApplyModel *applyCash) {
			[SVProgressHUD dismiss];
			MSFUserInfomationViewController *userInfoVC = [[MSFUserInfomationViewController alloc] initWithViewModel:self.viewModel.formsViewModel services:self.viewModel.services];
			userInfoVC.showNextStep = NO;
			[self.navigationController pushViewController:userInfoVC animated:YES];
//			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"personal" bundle:nil];
//			UIViewController <MSFReactiveView> *vc = storyboard.instantiateInitialViewController;
//			vc.hidesBottomBarWhenPushed = YES;
//			self.viewModel.formsViewModel.model.applyNo = applyCash.applyNo;
//			self.viewModel.formsViewModel.model.loanId = applyCash.applyID;
//			self.viewModel.formsViewModel.model.personId = applyCash.personId;
//			MSFAddressViewModel *addressViewModel = [[MSFAddressViewModel alloc] initWithAddress:self.viewModel.formsViewModel.currentAddress services:self.viewModel.services];
//			MSFPersonalViewModel *viewModel = [[MSFPersonalViewModel alloc] initWithFormsViewModel:self.viewModel.formsViewModel addressViewModel:addressViewModel];
//			[vc bindViewModel:viewModel];
//			[self.navigationController pushViewController:vc animated:YES];
		}];
	}];
	[self.viewModel.executeRequest.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	
	
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *urlString = [[request URL] absoluteString];
	urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	if ([urlString rangeOfString:@"objc"].length != 0) {
		[self.viewModel.executeRequest execute:nil];
		return NO;
	}
	return YES;
}

@end
