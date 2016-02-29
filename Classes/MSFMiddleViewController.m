//
// MSFMiddleViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFMiddleViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
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
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
