//
//  MSFCreditMiddleViewController.m
//  Finance
//
//  Created by Wyc on 16/3/8.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFCreditMiddleViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFCreditViewModel.h"

@interface MSFCreditMiddleViewController ()

@property (nonatomic, weak) MSFCreditViewModel *viewModel;
@property (nonatomic, weak) IBOutlet UIView *groundView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UILabel *numberLabel;
@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *cardLabel;
@property (nonatomic, weak) IBOutlet UILabel *reasonLabel;
@property (nonatomic, weak) IBOutlet UILabel *termLabel;

@end

@implementation MSFCreditMiddleViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	RAC(self.groundView, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber *status) {
		return @(!(status.integerValue == MSFApplicationActivated || status.integerValue == MSFApplicationNone));
	}];
	RAC(self.contentView, hidden) = [RACObserve(self, viewModel.status) map:^id(NSNumber *status) {
		return @((status.integerValue == MSFApplicationActivated || status.integerValue == MSFApplicationNone));
	}];
	
	RAC(self, numberLabel.text) = RACObserve(self, viewModel.applyNumber);
	RAC(self, amountLabel.text) = RACObserve(self, viewModel.applyAmouts);
	RAC(self, termLabel.text) = RACObserve(self, viewModel.applyTerms);
	RAC(self, cardLabel.text) = RACObserve(self, viewModel.applyCard);
	RAC(self, reasonLabel.text) = RACObserve(self, viewModel.applyReason);
	
//	RAC(self.amountLabel, text) = RACObserve(self, viewModel.repayAmounts);
//	RAC(self.subtitleLabel, text) = RACObserve(self, viewModel.repayDates);
//	
//	RAC(self.applyButton, rac_command) = RACObserve(self, viewModel.executeDrawCommand);
//	RAC(self.repayButton, rac_command) = RACObserve(self, viewModel.executeRepayCommand);
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

@end
