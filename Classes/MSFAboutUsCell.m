//
//  MSFAboutUsCell.m
//  Cash
//
//  Created by xutian on 15/5/18.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFAboutUsCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFUtils.h"
#import "MSFAgreementViewModel.h"

@implementation MSFAboutUsCell

- (void)viewDidLoad {
  self.title = @"关于我们";

	[SVProgressHUD showWithStatus:@"正在加载..."];
	[[[_aboutWebView
		rac_liftSelector:@selector(loadHTMLString:baseURL:)
		withSignalOfArguments:[RACSignal combineLatest:@[MSFUtils.agreementViewModel.aboutAgreementSignal,[RACSignal return:nil]]]]
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