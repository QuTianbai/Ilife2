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

@interface MSFMyOrderListProductsDetailViewController ()

@property (nonatomic, strong) MSFMyOrderListProductsViewModel *viewModel;

@end

@implementation MSFMyOrderListProductsDetailViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = @"订单详情";
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
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
			return cell;
		} else if (indexPath.row == 1) {
			cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderProductDetailContrractNoCell class])];
			if (cell == nil) {
				cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderProductDetailContrractNoCell class]) owner:nil options:nil].firstObject ;
			}
			return cell;
		}
	} else if (indexPath.section == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderProductsCell class])];
		if (cell == nil) {
			cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderProductsCell class]) owner:nil options:nil].firstObject ;
		}
		
		return cell;
	}
	cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MSFMyOrderProdutBottomCell class])];
	if (cell == nil) {
		cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MSFMyOrderProdutBottomCell class]) owner:nil options:nil].firstObject ;
	}
	
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2;
	} else if (section == 2) {
		return 1;
	}
    return 0;
}

@end
