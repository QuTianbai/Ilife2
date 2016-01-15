//
//  MSFOrderDetailViewController.m
//  Finance
//
//  Created by 赵勇 on 12/22/15.
//  Copyright © 2015 MSFINANCE. All rights reserved.
//

#import "MSFOrderDetailViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFOrderListCell.h"
#import "MSFOrderDetail.h"
#import "MSFClient+MSFOrder.h"
#import "UIColor+Utils.h"
#import "MSFDimensionalCodeViewModel.h"
#import "MSFDimensionalCodeViewController.h"
#import "MSFBlurButton.h"
#import "MSFInputTradePasswordViewController.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "MSFClient+Payment.h"
#import "MSFPayment.h"
#import "MSFCommodity.h"

@interface MSFOrderDetailViewController () <MSFInputTradePasswordDelegate>

@property (nonatomic, weak) id<MSFViewModelServices>services;
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) MSFOrderDetail *order;

@end

@implementation MSFOrderDetailViewController {
	MSFInputTradePasswordViewController *pvc;
}

- (instancetype)initWithOrderId:(NSString *)orderId services:(id<MSFViewModelServices>)services {
	self = [super initWithStyle:UITableViewStyleGrouped];
	if (self) {
		_services = services;
		_orderId = orderId;
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = @"订单详情";
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"left_arrow"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
	self.tableView.backgroundColor = UIColor.whiteColor;
	[self.tableView registerClass:MSFOrderListCell.class forCellReuseIdentifier:@"MSFOrderListCell"];
	[self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"Cell"];
	
	@weakify(self)
	[[self.services.httpClient fetchOrder:self.orderId] subscribeNext:^(id x) {
		@strongify(self)
		self.order = x;
		[self.tableView reloadData];
		UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"支付" style:UIBarButtonItemStyleDone target:nil action:nil];
		if ([self.order.orderStatus isEqualToString:@"3"]) {
			self.navigationItem.rightBarButtonItem = item;
			self.navigationItem.rightBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
				return self.paymentSignal;
			}];
		}
	} error:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:@"获取订单详情失败"];
	}];
}

- (RACSignal *)paymentSignal {
	pvc = [UIStoryboard storyboardWithName:@"InputTradePassword" bundle:nil].instantiateInitialViewController;
	pvc.delegate = self;
	[[UIApplication sharedApplication].keyWindow addSubview:pvc.view];
	return RACSignal.empty;
}

- (void)back {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.order.cmdtyList.count > 0) {
		return self.order.cmdtyList.count + 2 + (([self.order.orderStatus isEqualToString:@"3"]) ? 1 : 0);
	}
	return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 4;
	} else if (section == 1) {
		return 4;
	} else if (section == self.order.cmdtyList.count + 2) {
		return 0;
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
	if (section == self.order.cmdtyList.count + 2) label.text = @"";
	return reuse;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == self.order.cmdtyList.count + 2) {
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
		MSFBlurButton *button = [MSFBlurButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(10, 5, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 34);
		[button setTitle:@"确认支付" forState:UIControlStateNormal];
		[[[button rac_signalForControlEvents:UIControlEventTouchUpInside]
			takeUntil:cell.rac_prepareForReuseSignal]
			subscribeNext:^(id x) {
				MSFDimensionalCodeViewModel *viewModel = [[MSFDimensionalCodeViewModel alloc] initWithModel:self.order];
				MSFDimensionalCodeViewController *vc = [[MSFDimensionalCodeViewController alloc] initWithViewModel:viewModel];
				[self.navigationController pushViewController:vc animated:YES];
			}];
		[cell addSubview:button];
		return cell;
	}
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
			case 2: {
				NSString *content = [NSString stringWithFormat:@"￥%@×%@期", self.order.mthlyPmtAmt, self.order.loanTerm];
				[cell setTitle:@"贷款期数" content:content isList:NO]; break;
			}
			case 3: [cell setTitle:[NSString stringWithFormat:@"%@加入寿险计划", self.order.valueAddedSvc ? @"已" : @"未"] content:nil isList:NO]; break;
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

#pragma mark - MSFInputTradePasswordDelegate

- (void)getTradePassword:(NSString *)pwd type:(int)type  {
	[SVProgressHUD showWithStatus:@"正在支付..."];
	[[self.services.httpClient paymentWithOrder:self.order password:pwd] subscribeNext:^(id x) {
		[SVProgressHUD dismiss];
		MSFDimensionalCodeViewModel *viewModel = [[MSFDimensionalCodeViewModel alloc] initWithPayment:x order:self.order];
		MSFDimensionalCodeViewController *vc = [[MSFDimensionalCodeViewController alloc] initWithViewModel:viewModel];
		[self.navigationController pushViewController:vc animated:YES];
	} error:^(NSError *error) {
		[SVProgressHUD showErrorWithStatus:error.userInfo[NSLocalizedFailureReasonErrorKey]];
	}];
}

@end
