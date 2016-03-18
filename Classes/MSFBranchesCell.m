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
#import "MSFClient+Agreements.h"
#import "MSFServer.h"

@implementation MSFBranchesCell

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"网点分布";
	MSFClient *client = [[MSFClient alloc] initWithServer:MSFServer.dotComServer];
	[SVProgressHUD showWithStatus:@"正在加载..."];
	[[[_branchWebView
		rac_liftSelector:@selector(loadHTMLString:baseURL:)
		withSignalOfArguments:[RACSignal combineLatest:@[[client fetchUserAgreementWithType:MSFAgreementTypeAddresses], [RACSignal return:nil]]]]
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