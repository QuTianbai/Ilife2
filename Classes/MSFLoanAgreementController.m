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
#import "MSFLoanAgreementViewModel.h"
#import "MSFPersonalViewModel.h"
#import "MSFAddressViewModel.h"
#import "MSFAddressCodes.h"

#import "MSFSubmitApplyModel.h"
#import "MSFUserInfomationViewController.h"

#import "MSFEdgeButton.h"
#import "MSFApplyCashViewModel.h"

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
	self.title = @"个人消费信贷申请协议";
  self.LoanAgreenmentWV.delegate = self;
	self.edgesForExtendedLayout = UIRectEdgeNone;
	[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
	//!!!: 优化协议网页加载失败，返回错误的json信息的时候，处理统一按钮无法点击
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
	self.submitButton.rac_command = self.viewModel.executeAcceptCommand;
	self.LoanAgreenmentWV.scrollView.delegate = self;
	self.submitButton.enabled = NO;
	self.submitButton.hidden = YES;
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
		self.submitButton.enabled = YES;
	}
}

@end
