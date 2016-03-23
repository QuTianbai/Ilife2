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
#import "MSFDeviceGet.h"

@interface MSFCreditHeaderViewController ()

@property (nonatomic, weak) MSFCreditViewModel *viewModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHTop;

@end

@implementation MSFCreditHeaderViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    if (([MSFDeviceGet deviceNum] & liter4s) && [[[UIDevice currentDevice] systemVersion] floatValue] < 8 ) {
        self.headerHTop.constant = 70;
    }
	
	RAC(self.titleLabel, text) = RACObserve(self, viewModel.title);
	RAC(self.subtitleLabel, text) = RACObserve(self, viewModel.subtitle);
	RAC(self.repayLabel, text) = [RACObserve(self, viewModel.monthRepayAmounts) map:^id(id value) {
		return [NSString stringWithFormat:@"%@元", value?:@"0.00"];
	}];
	RAC(self.applyLabel, text) = RACObserve(self, viewModel.applyAmouts);
	RAC(self.applyMonthLabel, text) = [RACObserve(self, viewModel.applyTerms) map:^id(id value) {
		return [NSString stringWithFormat:@"%@个月", value?:@"0"];
	}];
	
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
	
	self.button.rac_command = self.viewModel.excuteActionCommand;
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
