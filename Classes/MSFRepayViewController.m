//
//	MSFRepayViewController.m
//	Cash
//
//	Created by xutian on 15/6/6.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFRepayViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <Masonry/Masonry.h>
#import "MSFAgreementViewModel.h"
#import "MSFAgreement.h"
#import "MSFUtils.h"

@interface MSFRepayViewController ()

@end

@implementation MSFRepayViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	UIWebView *webView = UIWebView.new;
	webView.delegate = self;
	[self.view addSubview:webView];
	[webView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	[SVProgressHUD showWithStatus:@"正在加载..."];
	[[[webView
		 rac_liftSelector:@selector(loadHTMLString:baseURL:)
		 withSignalOfArguments:[RACSignal combineLatest:@[MSFUtils.agreementViewModel.repayAgreementSignal, [RACSignal return:nil]]]]
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

}

@end
