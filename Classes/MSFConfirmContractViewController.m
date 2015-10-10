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

@interface MSFConfirmContractViewController ()<UIWebViewDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *confirmContractWebView;

@property (nonatomic, strong) MSFConfirmContactViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UIButton *button;

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
	
	RACSignal *signal = [self.viewModel requestContactInfo];
	[[self.confirmContractWebView rac_liftSelector:@selector(loadHTMLString:baseURL:) withSignalOfArguments:[RACSignal combineLatest:@[signal, [RACSignal return:nil]]]] subscribeNext:^(id x) {
		//[SVProgressHUD dismiss];
	}];
	
	@weakify(self)
	[self.viewModel.requestConfirmCommand.executionSignals subscribeNext:^(RACSignal *signal) {
		@strongify(self)
		[SVProgressHUD showWithStatus:@"正在加载..."];
		[signal subscribeNext:^(MSFConfirmContractModel *model) {
			if ([model.errorCode isEqualToString:@"0"]) {
				[SVProgressHUD showSuccessWithStatus:@"合同确认成功"];
				[[NSNotificationCenter defaultCenter] postNotificationName:@"MSFREQUESTCONTRACTSNOTIFACATIONHIDDENBT" object:nil];
				[self.navigationController popViewControllerAnimated:YES];
			} else {
				[SVProgressHUD showErrorWithStatus:@"确认失败，请稍后重试"];
			}
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
	
	NSArray *types = @[@"INTRODUCTION",@"CASH_CONTRACT",@"IMPORTENT_ITEM"];
	static int index = 0;
	[[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		if (index == 3) {
			[self.navigationController popToRootViewControllerAnimated:YES];
			return;
		}
		@strongify(self)
		[[self.viewModel.requestConfirmCommand execute:types[index]] subscribeNext:^(id x) {
			index++;
			RACSignal *signal = [self.viewModel requestContactInfo];
			[[self.confirmContractWebView rac_liftSelector:@selector(loadHTMLString:baseURL:) withSignalOfArguments:[RACSignal combineLatest:@[signal, [RACSignal return:nil]]]] subscribeNext:^(id x) {
				//[SVProgressHUD dismiss];
			}];
		}];
	}];
	
	self.button.enabled = NO;
	self.confirmContractWebView.scrollView.delegate = self;
}

- (RACSignal *)loanAgreementSignalWithViewModel:(MSFApplyCashVIewModel *)product {
	return [[self.viewModel.services.httpClient
					 fetchAgreementURLWithProduct:product]
					flattenMap:^RACStream *(id value) {
						return [[NSURLConnection rac_sendAsynchronousRequest:value]
										reduceEach:^id(NSURLResponse *response, NSData *data){
											return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
										}];
					}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//	[SVProgressHUD showWithStatus:@"正在加载..."];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
		NSLog(@"BOTTOM REACHED");
		self.button.enabled = YES;
	}
}

@end
