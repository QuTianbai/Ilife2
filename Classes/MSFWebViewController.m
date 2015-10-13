//
// MSFWebViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFWebViewController.h"
#import <Masonry/Masonry.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <libextobjc/extobjc.h>
#import <AFNetworking/UIWebView+AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFWebViewModel.h"

@interface MSFWebViewController () <UIWebViewDelegate>

@property (nonatomic, strong) NSURL *HTMLURL;
@property (nonatomic, strong) NSURLRequest *request;
@property (nonatomic, strong) MSFWebViewModel *viewModel;

@end

@implementation MSFWebViewController

- (instancetype)initWithViewModel:(MSFWebViewModel *)viewModel {
	self = [super init];
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	
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
	[[self rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(id x) {
		[SVProgressHUD dismiss];
	}];
	[[self rac_signalForSelector:@selector(webViewDidFinishLoad:) fromProtocol:@protocol(UIWebViewDelegate)]
		subscribeNext:^(RACTuple *x) {
			UIWebView *webView = x.last;
			NSString *theTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
			self.title = theTitle;
		}];
	
	if (!self.viewModel) {
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
		 return;
	}
	
	[[[webView
		rac_liftSelector:@selector(loadHTMLString:baseURL:)
		withSignalOfArguments:[RACSignal combineLatest:@[
			self.viewModel.HTMLSignal,
			[RACSignal return:nil]
		]]]
		deliverOn:RACScheduler.mainThreadScheduler]
		subscribeNext:^(id x) {
			[SVProgressHUD dismiss];
		}
		error:^(NSError *error) {
			[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
		}];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	
}

@end
