//
// MSFSignUpWebViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSignUpWebViewController.h"
#import "MSFAuthorizeViewModel.h"
#import <AFNetworking/UIWebView+AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFIntergrant.h"
#import "MSFClient.h"
#import "MSFClient.h"

@interface MSFSignUpWebViewController () <UIWebViewDelegate>

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;

@end

@implementation MSFSignUpWebViewController

@synthesize pageIndex;

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	self.webView.delegate = self;
	self.webView.backgroundColor = [UIColor clearColor];
	self.webView.opaque = NO;
	
	if (!self.viewModel.upgrade) return;
	
	NSURLRequest *request = [[self.viewModel.services httpClient] requestWithMethod:@"GET" path:[self.viewModel.upgrade relativeStringWithType:@"1"] parameters:nil];
	if (![self.viewModel.services httpClient].isAuthenticated) {
		request = [[self.viewModel.services httpClient] requestWithMethod:@"GET" path:[self.viewModel.upgrade relativeStringWithType:@"0"] parameters:nil];
	}
	[self.webView loadRequest:request progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
	} success:^NSString *(NSHTTPURLResponse *response, NSString *_HTML) {
		return _HTML;
	} failure:^(NSError *error) {
		[SVProgressHUD dismiss];
	}];
	
	@weakify(self)
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:nil action:nil];
	self.navigationItem.leftBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		@strongify(self)
		[self dismissViewControllerAnimated:YES completion:nil];
		return [RACSignal empty];
	}];
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if ([request.URL.absoluteString hasPrefix:@"https://itunes.apple.com"]) {
		[[UIApplication sharedApplication] openURL:request.URL];
		return NO;
	}
	return YES;
}

@end
