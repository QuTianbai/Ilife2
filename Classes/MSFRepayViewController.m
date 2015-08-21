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
	//TODO: 缺少贷款合同内容加载，以前的加载代码不正确
	[webView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	[SVProgressHUD showWithStatus:@"正在加载..."];
	[[self rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(id x) {
		[SVProgressHUD dismiss];
	}];

}

@end
