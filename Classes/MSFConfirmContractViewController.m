//
//  MSFConfirmContractViewController.m
//  Finance
//
//  Created by xbm on 15/9/2.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFConfirmContractViewController.h"
#import "MSFConfirmContactViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFConfirmContractModel.h"

@interface MSFConfirmContractViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *confirmContractWebView;

@property (nonatomic, strong) MSFConfirmContactViewModel *viewModel;

@end

@implementation MSFConfirmContractViewController

- (instancetype)initWithViewModel:(id)viewModel {
	//self = [super init];
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
	//self.confirmContractWebView.scrollView.bounces = NO;
	RACSignal *signal = [self.viewModel requestContactInfo];
	[SVProgressHUD showWithStatus:@"正在加载..."];
	[[self.confirmContractWebView rac_liftSelector:@selector(loadHTMLString:baseURL:) withSignalOfArguments:[RACSignal combineLatest:@[signal, [RACSignal return:nil]]]] subscribeNext:^(id x) {
		[SVProgressHUD dismiss];
	}];
	@weakify(self)
	[self.viewModel.requestConfirmCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在加载..."];
		[signal subscribeNext:^(MSFConfirmContractModel *model) {
			[SVProgressHUD dismiss];
			if ([model.errorCode isEqualToString:@"0"]) {
				[self.navigationController popViewControllerAnimated:YES];
			} else {
				[SVProgressHUD showErrorWithStatus:@"确认失败，请稍后重试"];
			}
			
		} error:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
	}];
	
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	NSString *urlString = [[request URL] absoluteString];
	urlString = [urlString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	if ([urlString rangeOfString:@"objc"].length != 0) {
		[self.viewModel.requestConfirmCommand execute:nil];
		return NO;
	}
	return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
