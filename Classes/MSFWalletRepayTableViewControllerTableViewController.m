//
//  MSFWalletRepayTableViewControllerTableViewController.m
//  Finance
//
//  Created by Wyc on 16/3/17.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFWalletRepayTableViewControllerTableViewController.h"
#import "MSFWalletRepayTableViewCell.h"
#import "MSFWalletRepayPlansViewModel.h"
#import "MSFWalletViewModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "MSFTabBarViewModel.h"
#import "MSFCommandView.h"
#import "MSFTableViewBindingHelper.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface MSFWalletRepayTableViewControllerTableViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) MSFWalletRepayPlansViewModel *viewModel;
@property (nonatomic, strong) MSFTableViewBindingHelper *bindingHelper;

@end

@implementation MSFWalletRepayTableViewControllerTableViewController

- (instancetype)initWithViewModel:(id)viewModel {
    self = [super init];
    if (!self) {
        return nil;
    }
    _viewModel = viewModel;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.backgroundColor = [MSFCommandView getColorWithString:@"#F6F6F6"];
    self.title = @"账单明细";
    //self.dataArray = [[NSArray alloc]init];
    [SVProgressHUD showWithStatus:@"正在加载..." maskType:SVProgressHUDMaskTypeClear];
	
	UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
	tableHeaderView.backgroundColor = [UIColor clearColor];
	self.tableView.tableHeaderView = tableHeaderView;
	self.tableView.emptyDataSetSource = self;
	self.tableView.emptyDataSetDelegate = self;
	self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self settableViewCustom];
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.viewModel.active = YES;
	self.viewModel.active = NO;
}

- (void)settableViewCustom {
	//@weakify(self)
	self.bindingHelper = [[MSFTableViewBindingHelper alloc]
												initWithTableView:self.tableView sourceSignal:[self.viewModel.executeFetchCommand.executionSignals flattenMap:^RACStream *(id value) {
		return value;
	}]
	selectionCommand:[[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal empty];
		
	}]  templateCell:[UINib nibWithNibName:NSStringFromClass([MSFWalletRepayTableViewCell class]) bundle:nil]];
	self.bindingHelper.delegate = self;

}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
	NSString *title = @"您还没有还款计划";
	
	return [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]}];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
	return [UIImage imageNamed:@"cell-icon-normal.png"];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

@end
