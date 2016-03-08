//
//  MSFMyOrderListProductsDetailViewController.m
//  Finance
//
//  Created by xbm on 16/3/3.
//  Copyright © 2016年 MSFINANCE. All rights reserved.
//

#import "MSFMyOrderListProductsDetailViewController.h"
#import "MSFMyOrderProductDetailNameCell.h"
#import "MSFMyOrderProductDetailContrractNoCell.h"
#import "MSFMyOrderProductsCell.h"
#import "MSFMyOrderProdutBottomCell.h"
#import "MSFMyOrderListProductsViewModel.h"
#import "UIColor+Utils.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface MSFMyOrderListProductsDetailViewController ()

@property (nonatomic, strong) MSFMyOrderListProductsViewModel *viewModel;

@end

@implementation MSFMyOrderListProductsDetailViewController

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
	self.navigationItem.title = @"订单详情";
	self.tableView.separatorStyle = UITableViewCellAccessoryNone;
	self.tableView.backgroundColor = [UIColor signUpBgcolor];
	@weakify(self)
	[RACObserve(self, viewModel.cmdtyList) subscribeNext:^(id x) {
		@strongify(self)
		[self.tableView reloadData];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.viewModel.active = YES;
	self.viewModel.active = NO;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderProductDetailNameCell class])];
			if (cell == nil) {
				cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderProductDetailNameCell class]) owner:nil options:nil].firstObject;
				}
			[(MSFMyOrderProductDetailNameCell *)cell bindViewModel:self.viewModel];
			return cell;
		} else if (indexPath.row == 1) {
			cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderProductDetailContrractNoCell class])];
			if (cell == nil) {
				cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderProductDetailContrractNoCell class]) owner:nil options:nil].firstObject ;
			}
			[(MSFMyOrderProductDetailContrractNoCell *)cell bindViewModel:self.viewModel];
			return cell;
		}
	} else if (indexPath.section == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderProductsCell class])];
		if (cell == nil) {
			cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderProductsCell class]) owner:nil options:nil].firstObject ;
		}
		[(MSFMyOrderProductsCell *)cell bindViewModel:self.viewModel.cmdtyList[indexPath.row]];
		return cell;
	} else if (indexPath.section == 2) {
		
	}
	cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderProdutBottomCell class])];
	if (cell == nil) {
		cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderProdutBottomCell class]) owner:nil options:nil].firstObject ;
	}
	[(MSFMyOrderProdutBottomCell *)cell bindViewModel:self.viewModel];
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2;
	} else if (section == 3) {
		return 1;
	} else if (section == 2) {
		return self.viewModel.travelCompanInfoList.count;
	}
    return self.viewModel.cmdtyList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 3) {
		return 72;
	} if (indexPath.section == 1) {
		return 69;
	}
	return 44;
}

@end
