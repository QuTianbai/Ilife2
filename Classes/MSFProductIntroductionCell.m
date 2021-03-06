//
//	MSFProductIntroductionCell.m
//	Cash
//
//	Created by xutian on 15/5/18.
//	Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFProductIntroductionCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFServer.h"
#import "MSFClient+Agreements.h"

@implementation MSFProductIntroductionCell

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"产品介绍";
	MSFClient *client = [[MSFClient alloc] initWithServer:MSFServer.dotComServer];
	[SVProgressHUD showWithStatus:@"正在加载..."];
	[[[_productWebView
		rac_liftSelector:@selector(loadHTMLString:baseURL:)
		withSignalOfArguments:[RACSignal combineLatest:@[[client fetchUserAgreementWithType:MSFAgreementTypeIntro], [RACSignal return:nil]]]]
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