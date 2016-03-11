//
//  MSFCreditHeaderViewController.m
//  Finance
//
//  Created by Wyc on 16/3/8.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCreditHeaderViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFCreditViewModel.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface MSFCreditHeaderViewController ()

@property (nonatomic, weak) MSFCreditViewModel *viewModel;

@end

@implementation MSFCreditHeaderViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	RAC(self.titleLabel, text) = RACObserve(self, viewModel.title);
	RAC(self.subtitleLabel, text) = RACObserve(self, viewModel.subtitle);
	RAC(self.repayLabel, text) = RACObserve(self, viewModel.monthRepayAmounts);
	RAC(self.applyLabel, text) = RACObserve(self, viewModel.applyAmouts);
	RAC(self.applyMonthLabel, text) = RACObserve(self, viewModel.loanMonthes);
	
	RAC(self.beforeApplyView, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber *status) {
		return @(!(status.integerValue == MSFApplicationActivated || status.integerValue == MSFApplicationNone));
	}];
	RAC(self.applyView, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber *status) {
		return @((status.integerValue == MSFApplicationActivated || status.integerValue == MSFApplicationNone));
	}];
	
	@weakify(self)
	[RACObserve(self, viewModel.action) subscribeNext:^(id x) {
		@strongify(self)
		[self.button setTitle:x forState:UIControlStateNormal];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
	[self.viewModel.excuteActionCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
}

@end
