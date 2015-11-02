//
// MSFSignUpWebViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFSignUpWebViewController.h"
#import "MSFAuthorizeViewModel.h"
#import <AFNetworking/UIWebView+AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFIntergrant.h"

@interface MSFSignUpWebViewController ()

@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) MSFAuthorizeViewModel *viewModel;

@end

@implementation MSFSignUpWebViewController

@synthesize pageIndex;

#pragma mark - MSFReactiveView

- (void)viewDidLoad {
	[super viewDidLoad];
	self.webView.scalesPageToFit = YES;
	[SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
	[self.webView loadRequest:[NSURLRequest requestWithURL:self.viewModel.upgrade.HTMLURL] progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
	} success:^NSString *(NSHTTPURLResponse *response, NSString *HTML) {
		[SVProgressHUD dismiss];
		return HTML;
	} failure:^(NSError *error) {
		[SVProgressHUD dismiss];
	}];
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
