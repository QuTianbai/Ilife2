//
//	MSFLoanAgreementWebView.m
//	Cash
//
//	Created by xbm on 15/6/4.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFLoanAgreementController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import <SVProgressHUD/SVProgressHUD.h>
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
#import "MSFApplyCashVIewModel.h"

#import "MSFInventoryViewModel.h"
#import "MSFInventoryViewController.h"
#import "MSFSocialInsuranceCashViewModel.h"

@interface MSFLoanAgreementController ()<UIWebViewDelegate, UIScrollViewDelegate>

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
	[super viewDidLoad];
	self.title = @"贷款协议";
  self.LoanAgreenmentWV.delegate = self;
	self.edgesForExtendedLayout = UIRectEdgeNone;
	[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
	[[[self.LoanAgreenmentWV
		rac_liftSelector:@selector(loadHTMLString:baseURL:)
		withSignalOfArguments:[RACSignal combineLatest:@[self.viewModel.loanAgreementSignal, [RACSignal return:nil]]]]
		deliverOn:[RACScheduler mainThreadScheduler]]
		subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
	 } error:^(NSError *error) {
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
			self.viewModel.applicationViewModel.applicaitonNo = applyCash.appNo;
			MSFInventoryViewModel *viewModel = [[MSFInventoryViewModel alloc] initWithApplicationViewModel:self.viewModel.applicationViewModel];
			MSFInventoryViewController *viewController = [[MSFInventoryViewController alloc] initWithViewModel:viewModel];
			[self.navigationController pushViewController:viewController animated:YES];
		}];
	}];
	[self.viewModel.executeRequest.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	self.LoanAgreenmentWV.scrollView.delegate = self;
	self.submitButton.enabled = NO;
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *urlString = [[request URL] absoluteString];
	urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	if ([urlString rangeOfString:@"objc"].length != 0) {
		[self.viewModel.executeRequest execute:nil];
		return NO;
	}
	return YES;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
			NSLog(@"BOTTOM REACHED");
			self.submitButton.enabled = YES;
	}
}

@end
