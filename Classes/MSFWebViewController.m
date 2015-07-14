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

@interface MSFWebViewController () <UIWebViewDelegate>

@property(nonatomic,strong) NSURL *HTMLURL;

@end

@implementation MSFWebViewController

- (instancetype)initWithHTMLURL:(NSURL *)URL {
  self = [super init];
  if (!self) {
    return nil;
  }
  _HTMLURL = URL;
  
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
  
  @weakify(self)
  [webView loadRequest:[NSURLRequest requestWithURL:_HTMLURL]
   progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
		 [SVProgressHUD showWithStatus:@"正在加载...."];
   }
   success:^NSString *(NSHTTPURLResponse *response, NSString *HTML) {
		 [SVProgressHUD dismiss];
     return HTML;
   }
   failure:^(NSError *error) {
     @strongify(self)
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
