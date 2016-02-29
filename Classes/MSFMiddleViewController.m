//
// MSFMiddleViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFMiddleViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFWalletViewModel.h"

@interface MSFMiddleViewController ()

@property (nonatomic, weak) MSFWalletViewModel *viewModel;

@end

@implementation MSFMiddleViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	
	RAC(self.imageView, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber *status) {
		return @(status.integerValue == MSFWalletActivated);
	}];
	RAC(self.contentView, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber *status) {
		return @(status.integerValue != MSFWalletActivated);
	}];
	
	RAC(self.amountLabel, text) = RACObserve(self, viewModel.repayAmounts);
	RAC(self.subtitleLabel, text) = RACObserve(self, viewModel.repayDates);
	
	RAC(self.applyButton, rac_command) = RACObserve(self, viewModel.executeDrawCommand);
	RAC(self.repayButton, rac_command) = RACObserve(self, viewModel.executeRepayCommand);
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
