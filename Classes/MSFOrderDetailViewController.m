//
//  MSFOrderDetailViewController.m
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFOrderDetailViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "MSFOrderListCell.h"
#import "MSFOrderDetail.h"
#import "MSFClient+MSFOrder.h"
#import "UIColor+Utils.h"

@interface MSFOrderDetailViewController ()

@property (nonatomic, weak) id<MSFViewModelServices>services;
@property (nonatomic, strong) MSFOrderDetail *orderPartial;
@property (nonatomic, strong) MSFOrderDetail *order;

@end

@implementation MSFOrderDetailViewController

- (instancetype)initWithModel:(MSFOrderDetail *)model services:(id<MSFViewModelServices>)services {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		_services = services;
		_orderPartial = model;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = @"订单详情";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.tableView.backgroundColor = UIColor.whiteColor;
	[self.tableView registerClass:MSFOrderListCell.class forCellReuseIdentifier:@"MSFOrderListCell"];
	
	@weakify(self)
	[[self.services.httpClient fetchOrder:self.orderPartial.inOrderId] subscribeNext:^(id x) {
		@strongify(self)
		self.order = x;
		[self.tableView reloadData];
	} error:^(NSError *error) {
		
	}];
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.order.cmdtyList.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 4;
	} else if (section == 1) {
		return 4;
	} else {
		return 3;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 36.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *reuse = [[UIView alloc] init];
	reuse.backgroundColor = UIColor.darkBackgroundColor;
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 36)];
	label.font = [UIFont systemFontOfSize:15.f];
	if (section == 0) {
		label.text = @"订单信息";
	} else if (section == 1) {
		label.text = @"分期";
	} else {
		label.text = @"商品信息";
	}
	[reuse addSubview:label];
	return reuse;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MSFOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MSFOrderListCell" forIndexPath:indexPath];
	if (indexPath.section == 0) {
		switch (indexPath.row) {
			case 0: [cell setTitle:@"订单编号" content:self.order.inOrderId isList:NO]; break;
			case 1: [cell setTitle:@"订单状态" content:self.order.orderStatus isList:NO]; break;
			case 2: [cell setTitle:@"姓名" content:self.order.custName isList:NO]; break;
			case 3: [cell setTitle:@"手机号" content:self.order.cellphone isList:NO]; break;
		}
	} else if (indexPath.section == 1) {
		switch (indexPath.row) {
			case 0: [cell setTitle:@"首付金额" content:self.order.downPmt isList:NO]; break;
			case 1: [cell setTitle:@"贷款金额" content:self.order.loanAmt isList:NO]; break;
			case 2: [cell setTitle:@"贷款期数" content:self.order.loanTerm isList:NO]; break;
			case 3: [cell setTitle:[NSString stringWithFormat:@"%@加入首先计划", self.order.valueAddedSvc ? @"已" : @"未"] content:nil isList:NO]; break;
		}
	} else {
		MSFCommodity *commodity = self.order.cmdtyList[indexPath.section - 2];
		switch (indexPath.row) {
			case 0: [cell setTitle:@"商品名称" content:commodity.cmdtyName isList:NO]; break;
			case 1: [cell setTitle:@"商品单价" content:commodity.cmdtyPrice isList:NO]; break;
			case 2: [cell setTitle:@"商品数量" content:commodity.pcsCount isList:NO]; break;
		}
	}
	return cell;
}

@end
