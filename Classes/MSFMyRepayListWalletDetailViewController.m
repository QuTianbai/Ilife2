//
//  MSFWalletViewController.m
//  Finance
//
//  Created by xbm on 16/3/2.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyRepayListWalletDetailViewController.h"
#import "MSFBlurButton.h"
#import "MSFMyRepayDetailViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFTableViewBindingHelper.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "MSFMyRepayDetailTableViewCell.h"
#import "MSFMyRepayListWalletDetailTableViewCell.h"

@interface MSFMyRepayListWalletDetailViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *dueMoneyLB;
@property (weak, nonatomic) IBOutlet UILabel *lastDueMoneyLB;
@property (weak, nonatomic) IBOutlet UIButton *repayPlanBT;
@property (weak, nonatomic) IBOutlet UILabel *timeRouteLB;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet MSFBlurButton *payMasteBT;

@property (nonatomic, strong) MSFMyRepayDetailViewModel *viewModel;
@property (nonatomic, strong) MSFTableViewBindingHelper *bindingHelper;

@end

@implementation MSFMyRepayListWalletDetailViewController

- (instancetype)initWithViewModel:(id)viewModel {
	self = [[UIStoryboard storyboardWithName:@"MSFMyRepayContainerViewController" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MSFMyRepayListWalletDetailViewController class])];
	if (!self) {
		return nil;
	}
	_viewModel = viewModel;
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"详情信息";
	self.edgesForExtendedLayout = UIRectEdgeNone;
	
	RAC(self, dueMoneyLB.text) = RACObserve(self, viewModel.appLmt);
	RAC(self, lastDueMoneyLB.text) = RACObserve(self, viewModel.latestDueMoney);
	RAC(self, timeRouteLB.text) = RACObserve(self, viewModel.latestDueDate);
	
	[self bindTableView];
	
	self.listTableView.emptyDataSetSource = self;
	self.listTableView.emptyDataSetDelegate = self;
	self.listTableView.allowsSelection = NO;
	self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.viewModel.active = YES;
	self.viewModel.active = NO;
}

#pragma mark private method

- (void)bindTableView {
	
	self.bindingHelper = [[MSFTableViewBindingHelper alloc] initWithTableView:self.listTableView sourceSignal:[self.viewModel.executeFetchCommand.executionSignals flattenMap:^RACStream *(id value) {
		return value;
	}] selectionCommand:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal empty];
	}] templateCell:[UINib nibWithNibName:NSStringFromClass([MSFMyRepayListWalletDetailTableViewCell class]) bundle:nil]];
	self.bindingHelper.delegate = self;
	
}

#pragma mark - ZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
	NSString *title = @"您还没有账单";
	
	return [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
	return [UIImage imageNamed:@"cell-icon-normal.png"];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 61;
}

@end