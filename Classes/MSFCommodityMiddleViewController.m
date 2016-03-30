//
//  MSFCommodityMiddleViewController.m
//  Finance
//
//  Created by xbm on 16/3/7.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCommodityMiddleViewController.h"
#import "MSFCommodityViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFCommodityMiddleViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (nonatomic, weak) MSFCommodityViewModel *viewModel;

@end

@implementation MSFCommodityMiddleViewController

- (void)viewDidLoad {
	[super viewDidLoad];
//	@weakify(self)
//	[RACObserve(self, viewModel.groundContent) subscribeNext:^(id x) {
//		@strongify(self)
//		[self.myWebView loadHTMLString:x baseURL:nil];
//	}];
//	self.myWebView.backgroundColor = [UIColor whiteColor];
//	self.myWebView.opaque = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
