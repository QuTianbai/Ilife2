//
//  MSFMyOrderListViewController.m
//  Finance
//
//  Created by xbm on 16/3/2.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderListViewController.h"
#import "MSFTableViewBindingHelper.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "MSFMyOderListsViewModel.h"
#import "MSFMyOrderListViewModel.h"
#import "MSFMyOrderListTableViewCell.h"
#import "MSFMyOrderListDetailViewController.h"
#import "MSFMyOrderListProductsViewModel.h"
#import "MSFMyOrderListProductsDetailViewController.h"

@interface MSFMyOrderListViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) MSFMyOderListsViewModel *viewModel;
@property (nonatomic, strong) MSFTableViewBindingHelper *bindingHelper;

@end

@implementation MSFMyOrderListViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"订单详情";
	self.tableView.allowsSelection = YES;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
	tableHeaderView.backgroundColor = [UIColor clearColor];
	self.tableView.tableHeaderView = tableHeaderView;
	self.tableView.emptyDataSetSource = self;
	self.tableView.emptyDataSetDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)bindViewModel:(id)viewModel {
	
	self.viewModel = viewModel;
	@weakify(self)
	self.bindingHelper = [[MSFTableViewBindingHelper alloc]
												initWithTableView:self.tableView sourceSignal:[self.viewModel.executeFetchCommand.executionSignals flattenMap:^RACStream *(id value) {
		return value;
	}]
												selectionCommand:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(MSFMyOrderListViewModel *input) {
		@strongify(self)
		if ([input.applyType isEqualToString:@"1"] || [input.applyType isEqualToString:@"4"]) {
			MSFMyOrderListDetailViewController *vc = [[MSFMyOrderListDetailViewController alloc] initWithViewModel:input];
			[self.navigationController pushViewController:vc animated:YES];
			return [RACSignal empty];
		}
		MSFMyOrderListProductsViewModel *viewModel = [[MSFMyOrderListProductsViewModel alloc] initWithServices:self.viewModel.services appNo:input.appNo];
		MSFMyOrderListProductsDetailViewController *vc = [[MSFMyOrderListProductsDetailViewController alloc] initWithViewModel:viewModel];
		[self.navigationController pushViewController:vc animated:YES];
		return [RACSignal empty];
	}]
												templateCell:[UINib nibWithNibName:NSStringFromClass([MSFMyOrderListTableViewCell class]) bundle:nil]];
	self.bindingHelper.delegate = self;
	
}

#pragma mark - ZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
	NSString *title = @"您还没有申请订单";
	if ([self.viewModel.identifer isEqualToString:@"1"]) {
		title = @"你还没有马上贷申请订单";
	} else if ([self.viewModel.identifer isEqualToString:@"4"]) {
		title = @"你还没有信用钱包申请订单";
	} else if ([self.viewModel.identifer isEqualToString:@"3"]) {
		title = @"你还没有商品贷申请订单";
	}
	return [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
	return [UIImage imageNamed:@"cell-icon-normal.png"];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
}

@end
