//
// MSFRegisterAgreementViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFRegisterAgreementViewController.h"
#import <Masonry/Masonry.h>
#import <libextobjc/extobjc.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFClient+Agreements.h"
#import "MSFServer.h"

@implementation MSFRegisterAgreementViewController

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFRegisterAgreementViewController `dealloc`");
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"用户注册协议";
	self.edgesForExtendedLayout = UIRectEdgeNone;
	UIWebView *webView = UIWebView.new;
	[self.view addSubview:webView];
	[webView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	[SVProgressHUD showWithStatus:@"正在加载..."];
	
	MSFClient *client = [[MSFClient alloc] initWithServer:MSFServer.dotComServer];
	[[[webView
		rac_liftSelector:@selector(loadHTMLString:baseURL:)
		withSignalOfArguments:[RACSignal combineLatest:@[
			[client fetchUserAgreementWithType:MSFAgreementTypeRegister],
			[RACSignal return:nil]
		]]]
		deliverOn:RACScheduler.mainThreadScheduler]
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
