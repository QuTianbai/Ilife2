//
//  MSFRepayViewController.m
//  Cash
//
//  Created by xutian on 15/6/6.
//  Copyright (c) 2015年 MSFINANCE. All rights reserved.
//

#import "MSFRepayViewController.h"
#import "MSFAgreementViewModel.h"
#import "MSFAgreement.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFUtils.h"
#import <Masonry/Masonry.h>
#import "MSFUtils.h"

@interface MSFRepayViewController ()

@end

@implementation MSFRepayViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  UIWebView *webView = UIWebView.new;
  webView.delegate = self;
  [self.view addSubview:webView];
  [webView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.equalTo(self.view);
  }];
  [webView
   rac_liftSelector:@selector(loadHTMLString:baseURL:)
   withSignalOfArguments:[RACSignal combineLatest:@[MSFUtils.agreementViewModel.repayAgreementSignal,[RACSignal return:nil]]]];
}

@end
