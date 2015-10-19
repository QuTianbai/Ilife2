//
// MSFWebViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFWebViewController.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import <AFNetworking/UIWebView+AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFWebViewModel.h"

@interface MSFWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) NSURL *HTMLURL;
@property (nonatomic, strong) NSURLRequest *request;

@end

@implementation MSFWebViewController

- (instancetype)initWithViewModel:(MSFWebViewModel *)viewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_HTMLURL = viewModel.URL;
	_request = [NSURLRequest requestWithURL:self.HTMLURL];
	
	return self;
}

- (instancetype)initWithHTMLURL:(NSURL *)URL {
	self = [super init];
	if (!self) {
		return nil;
	}
	_HTMLURL = URL;
	_request = [NSURLRequest requestWithURL:self.HTMLURL];
	
	return self;
}

- (instancetype)initWithRequest:(id)request {
	self = [super init];
	if (!self) {
		return nil;
	}
	_request = request;
	
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	UIWebView *webView = UIWebView.new;
	webView.delegate = self;
	[self.view addSubview:webView];
	[webView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.edges.equalTo(self.view);
	}];
	
	[SVProgressHUD showWithStatus:@"正在加载...."];

	[webView loadRequest:self.request
	 progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
	 }
	 success:^NSString *(NSHTTPURLResponse *response, NSString *HTML) {
		 [SVProgressHUD dismiss];
		 return HTML;
	 }
	 failure:^(NSError *error) {
		 [SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	 }];
	
	[[self rac_signalForSelector:@selector(webViewDidFinishLoad:) fromProtocol:@protocol(UIWebViewDelegate)]
	 subscribeNext:^(RACTuple *x) {
		 UIWebView *webView = x.last;
		 NSString *theTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
		 self.title = theTitle;
	 }];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
}

@end
