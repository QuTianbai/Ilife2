//
//  MSFMyRepayTableViewController.m
//  Finance
//
//  Created by xbm on 16/2/29.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyRepayTableViewController.h"
#import "MSFMyRepaysViewModel.h"
#import "MSFTableViewBindingHelper.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "MSFMyRepayTableViewCell.h"

@interface MSFMyRepayTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) MSFMyRepaysViewModel *viewModel;
@property (nonatomic, strong) MSFTableViewBindingHelper *bindingHelper;

@end

@implementation MSFMyRepayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.tableView.allowsSelection = YES;
	//self.tableView.
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
	self.bindingHelper = [[MSFTableViewBindingHelper alloc]
												initWithTableView:self.tableView
												sourceSignal:[self.viewModel.executeFetchCommand.executionSignals flattenMap:^RACStream *(id value) {
		return value;
	}]
												selectionCommand:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal empty];
	}]
												templateCell:[UINib nibWithNibName:NSStringFromClass([MSFMyRepayTableViewCell class]) bundle:nil]];
	self.bindingHelper.delegate = self;

}

#pragma mark - ZNEmptyDataSetSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
	NSString *title = @"您还没有还款订单";
	if ([self.viewModel.identifer isEqualToString:@"1"]) {
		title = @"你还没有马上贷还款订单";
	} else if ([self.viewModel.identifer isEqualToString:@"2"]) {
		title = @"你还没有信用钱包还款订单";
	} else if ([self.viewModel.identifer isEqualToString:@"3"]) {
		title = @"你还没有商品贷还款订单";
	}
	return [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
	NSString *subtitle = @"";
//	if ([self.viewModel.identifer isEqualToString:@"B"]) {
//		subtitle = @"你可以多多关注马上金融活动，惊喜连连！~";
//	}
	return [[NSAttributedString alloc] initWithString:subtitle attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
	return [UIImage imageNamed:@"cell-icon-normal.png"];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 57;
}

@end
