//
//  MSFConfirmContractViewController.m
//  Finance
//
//  Created by xbm on 15/9/2.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFConfirmContractViewController.h"
#import "MSFConfirmContractViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFConfirmContractModel.h"
#import "MSFCirculateCashModel.h"
#import "MSFApplyList.h"

@interface MSFConfirmContractViewController ()<UIWebViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *confirmContractWebView;

@property (nonatomic, strong) MSFConfirmContractViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UIButton *button;

@end

@implementation MSFConfirmContractViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [UIStoryboard storyboardWithName:@"ConfirmContract" bundle:nil].instantiateInitialViewController;
	if (!self) {
		return  nil;
	}
	
	_viewModel = viewModel;
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"确认合同";
	self.view.backgroundColor = [UIColor whiteColor];
	self.confirmContractWebView.delegate = self;
	self.edgesForExtendedLayout = UIRectEdgeNone;
	RACSignal *signal;
	if ([self.viewModel.model.productCd isEqualToString:@"4102"]) {
		[self.button setTitle:@"确定" forState:UIControlStateNormal];
		signal = [self.viewModel requestContactWithTemplate:@"CASH_CONTRACT" productType:self.viewModel.model.productCd];
	} else {
		signal = [self.viewModel requestContactWithTemplate:@"INTRODUCTION" productType:self.viewModel.model.productCd];
	}
	[[self.confirmContractWebView rac_liftSelector:@selector(loadHTMLString:baseURL:) withSignalOfArguments:[RACSignal combineLatest:@[signal, [RACSignal return:nil]]]] subscribeNext:^(id x) {
	}];
	
	@weakify(self)
	[self.viewModel.requestConfirmCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在加载..."];
		[signal subscribeNext:^(MSFConfirmContractModel *model) {
			[SVProgressHUD showSuccessWithStatus:@"合同确认成功"];
			[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFREQUESTCONTRACTSNOTIFACATIONHIDDENBT" object:nil];
			[self.navigationController popViewControllerAnimated:YES];
		} error:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
	}];
	
	[self.viewModel.requestConfirmCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	
	[[self rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(id x) {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFCONFIRMCONTACTIONLATERNOTIFICATION" object:nil];
	}];
	
	NSArray *types = @[
		@"CONTRACT_IMPORTENT_ITEM",
		@"CASH_CONTRACT"
	];
	static int index = 0;
	[[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		@strongify(self)
		// 社保贷合同确认提交按钮
		if ([self.viewModel.model.productCd isEqualToString:@"4102"]) {
			[[self.viewModel.requestConfirmCommand execute:nil] subscribeNext:^(id x) {
				[self.navigationController popToRootViewControllerAnimated:YES];
			}];
			return;
		}
		if (index == 2) {
			[[self.viewModel.requestConfirmCommand execute:nil] subscribeNext:^(id x) {
				[self.navigationController popToRootViewControllerAnimated:YES];
			}];
			
			return;
		}
		self.button.enabled = NO;
		[SVProgressHUD showWithStatus:@"正在加载..."];
		RACSignal *signal = [self.viewModel requestContactWithTemplate:types[index] productType:self.viewModel.model.productCd];
		[[self.confirmContractWebView
			rac_liftSelector:@selector(loadHTMLString:baseURL:)
			withSignalOfArguments:[RACSignal combineLatest:@[signal, [RACSignal return:nil]]]]
			subscribeNext:^(id x) {
				index++;
				if (index == 2) {
					[self.button setTitle:@"确定" forState:UIControlStateNormal];
				}
			}];
	}];
	
	[[self rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(id x) {
		index = 0;
	}];
	
	self.button.enabled = NO;
	self.confirmContractWebView.scrollView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[SVProgressHUD dismiss];
}

#pragma mark - UIWebView Delegate method

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *urlString = [[request URL] absoluteString];
	urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	if ([urlString rangeOfString:@"objc"].length != 0) {
		[self.viewModel.requestConfirmCommand execute:nil];
		return NO;
	}
	return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[SVProgressHUD dismiss];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
		self.button.enabled = YES;
	}
}

@end
