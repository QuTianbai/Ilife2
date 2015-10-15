//
// MSFAlertContentViewController.m
//
// Copyright (c) 2015 Zēng Liàng. All rights reserved.
//

#import "MSFAlertContentViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <Mantle/EXTScope.h>
#import "MSFAlertViewModel.h"

@interface MSFAlertContentViewController ()

@property (nonatomic, strong) MSFAlertViewModel *viewModel;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *terms;
@property (weak, nonatomic) IBOutlet UILabel *useage;
@property (weak, nonatomic) IBOutlet UILabel *repayment;
@property (weak, nonatomic) IBOutlet UILabel *bankNumber;

@end

@implementation MSFAlertContentViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	RAC(self.amount, text) = RACObserve(self, viewModel.amount);
	RAC(self.terms, text) = RACObserve(self, viewModel.terms);
	RAC(self.useage, text) = RACObserve(self, viewModel.useage);
	RAC(self.repayment, text) = RACObserve(self, viewModel.repayment);
	RAC(self.bankNumber, text) = RACObserve(self, viewModel.bankNumber);
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

#pragma mark - MSFReactiveView

- (void)bindViewModel:(id)viewModel {
	self.viewModel = viewModel;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
		[cell setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
		[cell setLayoutMargins:UIEdgeInsetsZero];
	}
}

- (void)viewDidLayoutSubviews {
	if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
		[self.tableView setSeparatorInset:UIEdgeInsetsZero];
	}
	
	if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
		[self.tableView setLayoutMargins:UIEdgeInsetsZero];
	}
}

@end
