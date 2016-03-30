//
// MSFMiddleViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFMiddleViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "MSFWalletViewModel.h"
#import "MSFPhoto.h"

@interface MSFMiddleViewController ()

@property (nonatomic, weak) MSFWalletViewModel *viewModel;

@end

@implementation MSFMiddleViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	RAC(self.groundView, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber *status) {
		return @(status.integerValue == MSFApplicationActivated);
	}];
	RAC(self.contentView, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber *status) {
		return @(status.integerValue != MSFApplicationActivated);
	}];
	
	RAC(self.amountLabel, text) = RACObserve(self, viewModel.totalOverdueMoney);
	RAC(self.subtitleLabel, text) = RACObserve(self, viewModel.repayDates);
	
	RAC(self.applyButton, rac_command) = RACObserve(self, viewModel.executeDrawCommand);
	RAC(self.repayButton, rac_command) = RACObserve(self, viewModel.executeRepayCommand);
//	@weakify(self)
//	[RACObserve(self, viewModel.groundContent) subscribeNext:^(id x) {
//		@strongify(self)
//		[self.webView loadHTMLString:x baseURL:nil];
//	}];
//	self.webView.backgroundColor = [UIColor whiteColor];
//	self.webView.opaque = NO;
    
    
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
	[self.viewModel.executeDrawCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
	[self.viewModel.executeRepayCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
}

@end
