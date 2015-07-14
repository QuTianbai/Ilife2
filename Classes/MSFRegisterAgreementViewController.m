//
// MSFRegisterAgreementViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFRegisterAgreementViewController.h"
#import <Masonry/Masonry.h>
#import <libextobjc/extobjc.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFAgreementViewModel.h"
#import "MSFUtils.h"

@implementation MSFRegisterAgreementViewController

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
	[webView
		rac_liftSelector:@selector(loadHTMLString:baseURL:)
		withSignalOfArguments:[RACSignal combineLatest:@[
			MSFUtils.agreementViewModel.registerAgreementSignal,
			[RACSignal return:nil]
		]]];
}

@end
