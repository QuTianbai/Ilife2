//
//	MSFVersionUpdate.m
//	Cash
//
//	Created by xutian on 15/5/18.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFBranchesCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFUtils.h"
#import "MSFAgreementViewModel.h"

@implementation MSFBranchesCell

- (void)viewDidLoad {
	
	self.title = @"网点分布";
	
	[SVProgressHUD showWithStatus:@"正在加载..."];
	[[[_branchWebView
		 rac_liftSelector:@selector(loadHTMLString:baseURL:)
		 withSignalOfArguments:[RACSignal combineLatest:@[MSFUtils.agreementViewModel.branchAgreementSignal, [RACSignal return:nil]]]]
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