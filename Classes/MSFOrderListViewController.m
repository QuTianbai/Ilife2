//
//  MSFOrderListViewController.m
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFOrderListViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "MSFOrderDetailViewController.h"
#import "MSFOrderListViewModel.h"
#import "MSFOrderDetail.h"

#import "MSFOrderListHeaderCell.h"
#import "MSFOrderListFooterCell.h"
#import "MSFOrderListItemCell.h"

#import "UIColor+Utils.h"

@interface MSFOrderListViewController ()

@property (nonatomic, strong) MSFOrderListViewModel *viewModel;

@end

@implementation MSFOrderListViewController

- (instancetype)initWithServices:(id<MSFViewModelServices>)services {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
		_viewModel = [[MSFOrderListViewModel alloc] initWithServices:services];
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = @"订单列表";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.tableView.backgroundColor = UIColor.darkBackgroundColor;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self.tableView registerClass:MSFOrderListHeaderCell.class forCellReuseIdentifier:@"MSFOrderListHeaderCell"];
	[self.tableView registerClass:MSFOrderListFooterCell.class forCellReuseIdentifier:@"MSFOrderListFooterCell"];
	[self.tableView registerClass:MSFOrderListItemCell.class forCellReuseIdentifier:@"MSFOrderListItemCell"];
	@weakify(self)
	[self.tableView addPullToRefreshWithActionHandler:^{
		@strongify(self)
		[self.viewModel.executeRefreshCommand execute:nil];
	}];
	[self.tableView addPullToRefreshWithActionHandler:^{
		@strongify(self)
		[self.viewModel.executeInfinityCommand execute:nil];
	}];
	[self.viewModel.executeRefreshCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
		@strongify(self)
		[self.tableView.pullToRefreshView stopAnimating];
	} error:^(NSError *error) {
		@strongify(self)
		[self.tableView.pullToRefreshView stopAnimating];
	}];
	[self.viewModel.executeInfinityCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
		@strongify(self)
		[self.tableView.infiniteScrollingView stopAnimating];
	} error:^(NSError *error) {
		@strongify(self)
		[self.tableView.infiniteScrollingView stopAnimating];
	}];
	[RACObserve(self, viewModel.orders) subscribeNext:^(id x) {
		@strongify(self)
		[self.tableView reloadData];
	}];
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.viewModel numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 0) {
		return 64.f;
	} else {
		return 40.f;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	if (section == [self.viewModel numberOfSections] - 1) {
		return 0.1f;
	}
	return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	if (section == [self.viewModel numberOfSections] - 1) {
		return nil;
	}
	UIView *reuse = [[UIView alloc] init];
	reuse.backgroundColor = UIColor.darkBackgroundColor;
	return reuse;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *identifier = [self.viewModel identifierForCellAtIndexPath:indexPath];
	MSFOrderDetail *order = self.viewModel.orders[indexPath.section];
	UITableViewCell<MSFReactiveView> *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if ([identifier isEqualToString:@"MSFOrderListItemCell"]) {
		[cell bindViewModel:order.cmdtyList[indexPath.row - 1]];
	} else {
		[cell bindViewModel:order];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MSFOrderDetail *order = self.viewModel.orders[indexPath.section];
	MSFOrderDetailViewController *vc = [[MSFOrderDetailViewController alloc] initWithModel:order services:self.viewModel.services];
	[self.navigationController pushViewController:vc animated:YES];
}

@end
