//
// MSFHeaderViewController.m
//
// Copyright (c) 2016 Zēng Liàng. All rights reserved.
//

#import "MSFHeaderViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFWalletViewModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFDeviceGet.h"

@interface MSFHeaderViewController ()

@property (nonatomic, weak) MSFWalletViewModel *viewModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHtop;
@property (weak, nonatomic) IBOutlet UILabel *allowMoney;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allowMoneyH;

@end

@implementation MSFHeaderViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    if ([MSFDeviceGet deviceNum] & liter4s) {
        self.headerHtop.constant = 40;
        self.allowMoneyH.constant = 95;
    }
	RAC(self.titleLabel, text) = RACObserve(self, viewModel.title);
	RAC(self.subtitleLabel, text) = RACObserve(self, viewModel.subtitle);
	RAC(self.totalLabel, text) = RACObserve(self, viewModel.totalAmounts);
	RAC(self.validLabel, text) = RACObserve(self, viewModel.validAmounts);
	RAC(self.usedLabel, text) = RACObserve(self, viewModel.usedAmounts);
	RAC(self.ratesLabel, text) = RACObserve(self, viewModel.loanRates);
	RAC(self.dateLabel, text) = RACObserve(self, viewModel.repayDate);
	
	RAC(self.applyView, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber *status) {
		return @(!(status.integerValue < MSFApplicationActivated));
	}];
	RAC(self.repayView, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber *status) {
		return @(!(status.integerValue == MSFApplicationActivated));
	}];
	
	@weakify(self)
	[RACObserve(self, viewModel.action) subscribeNext:^(id x) {
		@strongify(self)
		[self.button setTitle:x forState:UIControlStateNormal];
	}];
	
	RAC(self.button, rac_command) = RACObserve(self, viewModel.excuteActionCommand);
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
	[self.viewModel.excuteActionCommand.errors subscribeNext:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
}

@end
