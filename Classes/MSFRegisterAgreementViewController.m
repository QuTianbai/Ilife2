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
#import "MSFAgreementViewModel.h"
#import "MSFUtils.h"

@implementation MSFRegisterAgreementViewController

#pragma mark - Lifecycle

- (void)dealloc {
	NSLog(@"MSFRegisterAgreementViewController `dealloc`");
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.edgesForExtendedLayout = UIRectEdgeNone;
	UIWebView *webView = UIWebView.new;
	[self.view addSubview:webView];
	[webView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	[SVProgressHUD showWithStatus:@"正在加载..."];
	[[[webView
		 rac_liftSelector:@selector(loadHTMLString:baseURL:)
		 withSignalOfArguments:[RACSignal combineLatest:@[MSFUtils.agreementViewModel.registerAgreementSignal, [RACSignal return:nil]]]]
		deliverOn:
		[RACScheduler mainThreadScheduler]]
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
